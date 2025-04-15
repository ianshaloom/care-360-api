import 'dart:async';

import 'package:care360/constants/constants.dart';
import 'package:care360/models/care-giver-model/care_giver_model.dart';
import 'package:care360/models/request-model/request_model.dart';
import 'package:care360/models/shift-model/shift_model.dart';
import 'package:care360/services/messaging_service.dart';
import 'package:care360/utils/helpers/firestore_helper.dart';
import 'package:care360/utils/helpers/messaging_helper.dart';
import 'package:dart_firebase_admin/firestore.dart';

///
class ShiftAlgorithm {
  /// Constructor for [ShiftAlgorithm].
  ShiftAlgorithm(this._firestoreHelper, this._messagingHelper);

  final FirestoreHelper _firestoreHelper;
  final MessagingHelper _messagingHelper;

  /// Main function to Float request to caregivers
  Future<void> floatRequestShifts(RequestModel request) async {
    // Step 1: Fetch all available caregivers
    final caregivers = await fetchAvailableCaregivers();
    if (caregivers.isEmpty) {
      return;
    }

    // Step 2: Generate shifts from request
    final generatedShifts = request.generateShifts(clientId: 'none');

    // Step 3: Fetch existing shifts for the same date(s)
    final caregiverShiftCount =
        await _fetchCaregiverShiftCounts(generatedShifts);

    // --- Check if there are no shifts for the same date(s)
    if (caregiverShiftCount.isEmpty) {
      // fill the caregiverShiftCount with 0 for all caregivers
      for (final caregiver in caregivers) {
        caregiverShiftCount[caregiver.caregiverId] = 0;
      }
    }

    // Step 4: Sort caregivers by least assigned shifts (fair distribution)
    caregivers
      ..sort(
        (a, b) => (caregiverShiftCount[a.caregiverId] ?? 0)
            .compareTo(caregiverShiftCount[b.caregiverId] ?? 0),
      )

      // --- Remover where shifts count is greater than 2
      ..removeWhere((caregiver) {
        final assignedShifts = caregiverShiftCount[caregiver.caregiverId] ?? 0;
        return assignedShifts >= 2;
      });

    // Step 5: Assign shifts using round-robin while respecting 2-shift limit
    final assignableShifts = <ShiftModel>[];
    final unassignedShifts = <ShiftModel>[];
    final availableCareGivers = <CareGiverModel>[];
    var caregiverIndex = 0;

    for (final shift in generatedShifts) {
      var shiftAssigned = false;

      for (var i = 0; i < caregivers.length; i++) {
        final caregiver = caregivers[(caregiverIndex + i) % caregivers.length];
        final assignedShifts = caregiverShiftCount[caregiver.caregiverId] ?? 0;

        // --- if care giver has 0 shifts assigned, excute block and continue
        if (assignedShifts == 0) {
          if (!availableCareGivers.contains(caregiver)) {
            availableCareGivers.add(caregiver);
          }

          // add shift to assignable shifts
          assignableShifts.add(shift);

          // update the caregiver's shift count in the local map
          caregiverShiftCount[caregiver.caregiverId] = assignedShifts + 1;
          shiftAssigned = true;
          caregiverIndex = (caregiverIndex + 1) % caregivers.length;
          break;
        }

        // --- if care giver has at least 1 shift assigned, check if the shift
        // overlaps with the existing shift, if it does, continue to the next
        // care giver, if it does not, assign the shift to the care giver
        final s = DateTime(
          shift.startTime.year,
          shift.startTime.month,
          shift.startTime.day,
        );

        final e = s.add(
          const Duration(days: 1),
        );

        // check if there is an overlap ---
        final thereIsOverlap = await _fetchShiftsForCaregiverOnDate(
          caregiver.caregiverId,
          s,
          e,
          realStartTime: shift.startTime,
          realEndTime: shift.endTime,
        );

        // if there is an overlap, continue to the next care giver ---
        if (thereIsOverlap) {
          continue;
        }

        // else add the caregiver to the available caregivers list
        if (!availableCareGivers.contains(caregiver)) {
          availableCareGivers.add(caregiver);
        }

        // add shift to assignable shifts
        assignableShifts.add(shift);

        // update the caregiver's shift count in the local map
        caregiverShiftCount[caregiver.caregiverId] = assignedShifts + 1;
        shiftAssigned = true;
        caregiverIndex = (caregiverIndex + 1) % caregivers.length;
        break;
      }

      if (!shiftAssigned) {
        unassignedShifts.add(shift);
      }
    }

    // Add all the shifts that could be assigned to request sub collection
    if (assignableShifts.isNotEmpty) {
      await _storeAssignableShifts(assignableShifts, request.requestId);
    }

    // Add all the shifts that could not be assigned to unassigned shifts
    // collection
    if (unassignedShifts.isNotEmpty) {
      await _storeUnassignedShifts(unassignedShifts);
    }

    // Notify the available caregivers, first get tokens from the available
    unawaited(MessagingService(_messagingHelper, _firestoreHelper).multicast(
      'Open Shifts',
      'A new request has been floated, check out the available shifts',
      user: 'care-giver',
    ),);
  }

  /// Main function to Accept a Shift from a given request
  Future<void> acceptRequestShift(
    String requestId,
    String shiftId,
    String careGiverId,
  ) async {
    // Step 1: Fetch the shift from the request sub collection
    final snapshot = await _firestoreHelper.getSubDocument(
      requestCollection,
      requestId,
      assignableShiftCollection,
      shiftId,
    );

    if (snapshot.isEmpty) {
      throw Exception('Shift not found');
    }

    final shift = ShiftModel.fromSnapshot(snapshot);

    // Step 2: Check if there is an overlap
    final s = DateTime(
      shift.startTime.year,
      shift.startTime.month,
      shift.startTime.day,
    );

    final e = s.add(
      const Duration(days: 1),
    );

    final thereIsOverlap = await _fetchShiftsForCaregiverOnDate(
      careGiverId,
      s,
      e,
      realStartTime: shift.startTime,
      realEndTime: shift.endTime,
    );

    // if there is an overlap, continue to the next care giver ---
    if (thereIsOverlap) {
      throw Exception('Shift overlaps with existing shift');
    }

    // Step 3: Else Update the shift with the caregiverId
    final newShift = shift.copyWith(
      caregiverId: careGiverId,
      floatStatus: FloatStatus.picked,
      updatedAt: DateTime.now(),
    );

    await _firestoreHelper.updateSubDocument(
      requestCollection,
      requestId,
      assignableShiftCollection,
      shiftId,
      newShift.toDoc(),
    );

    // add the shift to scheduled shifts collection
    await _firestoreHelper.addDocument(
      scheduledShiftCollection,
      newShift.toDoc(),
      documentId: shiftId,
    );

    // Step 3: Update the caregiver's assigned shifts
    final caregiverSnapshot = await _firestoreHelper.getDocument(
      caregiverCollection,
      careGiverId,
    );

    if (caregiverSnapshot.isEmpty) {
      throw Exception('Caregiver not found');
    }

    final caregiver = CareGiverModel.fromSnapshot(caregiverSnapshot);

    final updatedCaregiver = caregiver.copyWith(
      assignedShifts: [...caregiver.assignedShifts, shiftId],
    );

    await _firestoreHelper.updateDocument(
      caregiverCollection,
      careGiverId,
      updatedCaregiver.toDoc(),
    );
  }

  /// Main function to assign shifts
  Future<void> assignShiftsFromRequest(RequestModel request) async {
    // Step 1: Fetch all available caregivers
    final caregivers = await fetchAvailableCaregivers();
    if (caregivers.isEmpty) {
      return;
    }

    // Step 2: Generate shifts from request
    final generatedShifts = request.generateShifts(clientId: 'none');

    // Step 3: Fetch existing shifts for the same date(s)
    final caregiverShiftCount =
        await _fetchCaregiverShiftCounts(generatedShifts);

    // Step 4: Sort caregivers by least assigned shifts (fair distribution)
    caregivers.sort(
      (a, b) => (caregiverShiftCount[a.caregiverId] ?? 0)
          .compareTo(caregiverShiftCount[b.caregiverId] ?? 0),
    );

    // Step 5: Assign shifts using round-robin while respecting 2-shift limit
    final unassignedShifts = <ShiftModel>[];
    var caregiverIndex = 0;

    for (var shift in generatedShifts) {
      var shiftAssigned = false;

      for (var i = 0; i < caregivers.length; i++) {
        final caregiver = caregivers[(caregiverIndex + i) % caregivers.length];
        final assignedShifts = caregiverShiftCount[caregiver.caregiverId] ?? 0;

        // --- if care giver has 0 shifts assigned, excute block and continue
        if (assignedShifts == 0) {
          shift = shift.copyWith(
            caregiverId: caregiver.caregiverId,
            updatedAt: DateTime.now(),
          );
          await _saveShift(shift);

          // Update caregiver's shift count --
          final c = caregiver.copyWith(
            assignedShifts: [shift.shiftId],
          );
          await _updateCaregiverShifts(caregiver.caregiverId, c.toDoc());

          caregiverShiftCount[caregiver.caregiverId] = assignedShifts + 1;
          shiftAssigned = true;
          caregiverIndex = (caregiverIndex + 1) % caregivers.length;

          // break out of the loop, since the shift has been assigned --
          break;
        }

        // --- if care giver has at least 1 shift assigned, check if the shift
        // overlaps with the existing shift, if it does, continue to the next
        // care giver, if it does not, assign the shift to the care giver
        final s = DateTime(
          shift.startTime.year,
          shift.startTime.month,
          shift.startTime.day,
        );

        final e = s.add(
          const Duration(days: 1),
        );

        // check if there is an overlap ---
        final thereIsOverlap = await _fetchShiftsForCaregiverOnDate(
          caregiver.caregiverId,
          s,
          e,
          realStartTime: shift.startTime,
          realEndTime: shift.endTime,
        );

        // if there is an overlap, continue to the next care giver ---
        if (thereIsOverlap) {
          continue;
        }

        // else assign the shift to the care giver ---
        shift = shift.copyWith(
          caregiverId: caregiver.caregiverId,
          updatedAt: DateTime.now(),
        );

        await _saveShift(shift);

        // Update caregiver's shift count
        final c = caregiver.copyWith(
          assignedShifts: [...caregiver.assignedShifts, shift.shiftId],
        );

        await _updateCaregiverShifts(caregiver.caregiverId, c.toDoc());

        // update the caregiver's shift count in the local map
        caregiverShiftCount[caregiver.caregiverId] = assignedShifts + 1;
        shiftAssigned = true;
        caregiverIndex = (caregiverIndex + 1) % caregivers.length;
        break;
      }

      if (!shiftAssigned) {
        unassignedShifts.add(shift);
      }
    }

    if (unassignedShifts.isNotEmpty) {
      await _storeUnassignedShifts(unassignedShifts);
    }
  }

  /// Fetch available caregivers
  Future<List<CareGiverModel>> fetchAvailableCaregivers() async {
    final snapshot = await _firestoreHelper.queryCollection(
      caregiverCollection,
      field: 'isAvailable',
      value: true,
    );

    return snapshot.docs
        .map(
          (doc) => CareGiverModel.fromSnapshot(
            doc.data() as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  /// Fetch caregiver shift counts for given shifts
  Future<Map<String, int>> _fetchCaregiverShiftCounts(
    List<ShiftModel> shifts,
  ) async {
    final shiftCounts = <String, int>{};

    for (final shift in shifts) {
      final startTime = DateTime(
        shift.startTime.year,
        shift.startTime.month,
        shift.startTime.day,
      );

      final endTime = startTime.add(
        const Duration(days: 1),
      );

      // Query Firestore for shifts on the same day as the current shift
      final snapshot =
          await _firestoreHelper.queryCollectionWithMultipleFilters(
        scheduledShiftCollection,
        fields: [
          'startTime',
          'endTime',
        ],
        values: [
          startTime,
          endTime,
        ],
        filters: [
          WhereFilter.greaterThanOrEqual,
          WhereFilter.lessThan,
        ],
      );

      if (snapshot.docs.isEmpty) {
        continue;
      }

      // Count shifts for each caregiver
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final caregiverId = data['caregiverId']! as String;
        shiftCounts[caregiverId] = (shiftCounts[caregiverId] ?? 0) + 1;
      }
    }
    return shiftCounts;
  }

  /// Save assigned shift to Firestore
  Future<void> _saveShift(ShiftModel shift) async {
    await _firestoreHelper.addDocument(
      scheduledShiftCollection,
      shift.toDoc(),
      documentId: shift.shiftId,
    );
  }

  /// Update caregiver's shift count
  Future<void> _updateCaregiverShifts(
    String caregiverId,
    Map<String, dynamic> data,
  ) async {
    await _firestoreHelper.updateDocument(
      caregiverCollection,
      caregiverId,
      data,
    );

    // Notify the caregiver
    unawaited(MessagingService(_messagingHelper, _firestoreHelper).send(
      'Request Assigned',
      'A request has been assigned to you',
      userId: caregiverId,
    ));
  }

  Future<bool> _fetchShiftsForCaregiverOnDate(
    String caregiverId,
    DateTime startTime,
    DateTime endTime, {
    required DateTime realStartTime,
    required DateTime realEndTime,
  }) async {
    // print('💡 --- $caregiverId  -- $startTime -- $endTime --- 💡');
    final snapshot = await _firestoreHelper.queryCollectionWithMultipleFilters(
      scheduledShiftCollection,
      fields: [
        'caregiverId',
        'startTime',
        'endTime',
      ],
      values: [
        caregiverId,
        startTime,
        endTime,
      ],
      filters: [
        WhereFilter.equal,
        WhereFilter.greaterThanOrEqual,
        WhereFilter.lessThan,
      ],
    );

    if (snapshot.docs.isEmpty) {
      return false;
    }

    final shifts = snapshot.docs
        .map(
          (doc) => ShiftModel.fromSnapshot(
            doc.data() as Map<String, dynamic>,
          ),
        )
        .toList();

    // loop through each shift and check if there is an overlap
    for (final shift in shifts) {
      final shiftStartTime = DateTime(
        shift.startTime.year,
        shift.startTime.month,
        shift.startTime.day,
        shift.startTime.hour,
        shift.startTime.minute,
      );

      final shiftEndTime = DateTime(
        shift.endTime.year,
        shift.endTime.month,
        shift.endTime.day,
        shift.endTime.hour,
        shift.endTime.minute,
      );

      // check if there is an overlap
      if (realStartTime.isBefore(
            shiftEndTime,
          ) &&
          realEndTime.isAfter(
            shiftStartTime,
          )) {
        return true;
      }
    }

    // else return true
    return true;
  }

  /// Store unassigned shifts for later processing
  Future<void> _storeUnassignedShifts(List<ShiftModel> shifts) async {
    for (final shift in shifts) {
      await _firestoreHelper.addDocument(
        unassignedShiftCollection,
        shift.toDoc(),
        documentId: shift.shiftId,
      );
    }

    // Notify the admins that a request has been created
    unawaited(MessagingService(_messagingHelper, _firestoreHelper).multicast(
      'Unassigned Shifts',
      'Some shifts could not be assigned, please check the unassigned shifts',
      user: 'admin',
    ));
  }

  /// Store assignable shifts in request sub collection
  Future<void> _storeAssignableShifts(
    List<ShiftModel> shifts,
    String requestId,
  ) async {
    for (final shift in shifts) {
      final newShift = shift.copyWith(
        clientId: '',
        caregiverId: '',
        floatStatus: FloatStatus.floating,
        updatedAt: DateTime.now(),
      );

      final doc = newShift.toDoc();

      await _firestoreHelper.addSubDocument(
        requestCollection,
        requestId,
        assignableShiftCollection,
        doc,
        subDocId: shift.shiftId,
      );
    }
  }
}
