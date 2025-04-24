import 'package:care360/constants/constants.dart';
import 'package:care360/models/care-giver-model/care_giver_model.dart';
import 'package:care360/models/request-model/request_model.dart';
import 'package:care360/models/shift-model/shift_model.dart';
import 'package:care360/utils/helpers/firestore_helper.dart';
import 'package:dart_firebase_admin/firestore.dart';

///
class ShiftDistributor {
  /// Constructor for [ShiftDistributor].
  ShiftDistributor(this._firestoreHelper);

  final FirestoreHelper _firestoreHelper;

  /// Main function to assign shifts
  Future<void> assignShiftsFromRequest(RequestModel request) async {
    // Step 1: Fetch all available caregivers
    final caregivers = await _fetchAvailableCaregivers();
    if (caregivers.isEmpty) {
      return;
    }

    // Step 2: Generate shifts from request
    final generatedShifts = request.generateShifts(request.clientId);

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
  Future<List<CareGiverModel>> _fetchAvailableCaregivers() async {
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
  }
}
