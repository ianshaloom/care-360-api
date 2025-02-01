import 'dart:math';

import 'package:care360/models/care-giver-model/care_giver_model.dart';
import 'package:care360/models/request-model/request_model.dart';
import 'package:care360/services/shift_service.dart';

/// A class that implements a matching algorithm to match caregivers to
/// requests.
class CaregiverMatchingAlgorithm {
  /// Return a [CareGiverModel] that matches the request.
  static Future<CareGiverModel?> matchedCaregiver(
    RequestModel request,
    List<CareGiverModel> caregivers,
    ShiftService s,
  ) async {
    final unavailableCaregivers = Set<String>.from(
      await unavailable(
        s,
        request.shiftStartTime,
        request.shiftEndTime,
      ),
    );

    final availableCaregivers = caregivers
        .where(
          (caregiver) => !unavailableCaregivers.contains(
            caregiver.caregiverId,
          ),
        )
        .toList();

    /// Randomly select a caregiver from the available caregivers
    if (availableCaregivers.isNotEmpty) {
      final l = availableCaregivers.length;

      final index = Random().nextInt(l);

      return availableCaregivers[index];
    }

    return null; // No available caregivers found
  }

  /// return a list of [CareGiverModel] that match the request.
  static Future<List<CareGiverModel>> matchedCaregivers(
    RequestModel request,
    List<CareGiverModel> caregivers,
    ShiftService s,
  ) async {
    final unavailableCaregivers = Set<String>.from(
      await unavailable(
        s,
        request.shiftStartTime,
        request.shiftEndTime,
      ),
    );

    final availableCaregivers = caregivers
        .where(
          (caregiver) => !unavailableCaregivers.contains(
            caregiver.caregiverId,
          ),
        )
        .toList();

    if (availableCaregivers.isNotEmpty) {
      return availableCaregivers;
    }

    return []; // No available caregivers found
  }

  /// Return a list of unavailable caregivers.
  static Future<List<String>> unavailable(
    ShiftService s,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final result = await s.queryShiftsByDates(startDate, endDate);

    final shifts = result.getOrElse(() => []);

    return shifts.map((shift) => shift.caregiverId).toList();
  }
}

/*
  static Future<List<CareGiverModel>> matchCaregiversList(
    RequestModel request,
    List<CareGiverModel> caregivers,
    ShiftService s,
  ) async {
    final matchedCaregivers = <CareGiverModel>[];

    // Iterate through all caregivers
    for (final caregiver in caregivers) {
      // Fetch shifts for the current caregiver
      final result = await s.getShiftsForCaregiver(caregiver.caregiverId);

      if (result.isLeft()) {
        // Handle error
        continue;
      }

      final shifts = result.getOrElse(() => []);

      // Check for shift overlap
      final hasOverlap = shifts.any(
        (shift) =>
            // Check for overlap logic as defined in Scenario 2
            (request.shiftStartTime.isAfter(shift.startTime) &&
                request.shiftStartTime.isBefore(shift.endTime)) ||
            (request.shiftEndTime.isAfter(shift.startTime) &&
                request.shiftEndTime.isBefore(shift.endTime)) ||
            (request.shiftStartTime.isBefore(shift.startTime) &&
                request.shiftEndTime.isAfter(shift.endTime)),
      );

      if (hasOverlap) continue;

      // Check qualifications, preferred care types, availability
      /*if (_meetsCriteria(caregiver, request)) {
        matchedCaregivers.add(caregiver);
      }*/
    }

    return matchedCaregivers; // No available caregivers found
  }*/
