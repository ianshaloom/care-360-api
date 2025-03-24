import 'package:care360/constants/constants.dart';
import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/models/clock-in-out-details/clock.dart';
import 'package:care360/models/shift-model/shift_model.dart';
import 'package:care360/services/messaging_service.dart';
import 'package:care360/utils/firestore_helper.dart';
import 'package:care360/utils/messaging_helper.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:dartz/dartz.dart';

/// Service class for managing shift-related operations.
class ShiftService {
  /// Constructor for [ShiftService].
  ShiftService(this._firestoreHelper, this._messagingHelper);

  final FirestoreHelper _firestoreHelper;
  final MessagingHelper _messagingHelper;

  /// Fetches a shift by its unique ID.
  Future<Either<Failure, ShiftModel>> getShift(
    String shiftId, {
    bool isSchduled = false,
  }) async {
    try {
      if (isSchduled) {
        final snapshot = await _firestoreHelper.getDocument(
          scheduledShiftCollection,
          shiftId,
        );

        if (snapshot.isEmpty) {
          throw Exception('Shift not found');
        }

        return Right(ShiftModel.fromSnapshot(snapshot));
      }

      final snapshot =
          await _firestoreHelper.getDocument(shiftCollection, shiftId);

      if (snapshot.isEmpty) {
        throw Exception('Shift not found');
      }

      return Right(ShiftModel.fromSnapshot(snapshot));
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch shift: $e',
        ),
      );
    }
  }

  /// Fetches all shifts from Firestore.
  Future<Either<Failure, List<ShiftModel>>> getAllShifts() async {
    try {
      final snapshot =
          await _firestoreHelper.getCollection(scheduledShiftCollection);

      final shifts = snapshot.docs
          .map(
            (doc) => ShiftModel.fromSnapshot(doc.data()),
          )
          .toList();
      return Right(shifts);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch shifts: $e',
        ),
      );
    }
  }

  /// Fetches all shifts assigned to a caregiver from Firestore.
  Future<Either<Failure, List<ShiftModel>>> getShiftsForCaregiver(
    String caregiverId,
  ) async {
    try {
      final snapshot = await _firestoreHelper.queryCollection(
        shiftCollection,
        field: 'caregiverId',
        value: caregiverId,
      );

      final shifts = snapshot.docs
          .map((doc) => ShiftModel.fromSnapshot(doc.data()))
          .toList();
      return Right(shifts);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch shifts: $e',
        ),
      );
    }
  }

  /// Creates a new shift in Firestore.
  Future<Either<Failure, String>> createShift(
    ShiftModel shift, {
    String collection = shiftCollection,
  }) async {
    try {
      final shiftData = shift.toDoc();
      final shiftId = await _firestoreHelper.addDocument(
        collection,
        shiftData,
        documentId: shift.shiftId,
      );
      return Right(shiftId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to create shift: $e',
        ),
      );
    }
  }

  /// Updates an existing shift in Firestore.
  Future<Either<Failure, String>> updateShift(
    ShiftModel shift, {
    bool isSchduled = false,
  }) async {
    try {
      final shiftData = shift.toDoc();

      if (isSchduled) {
        await _firestoreHelper.updateDocument(
          scheduledShiftCollection,
          shift.shiftId,
          shiftData,
        );

        return Right(shift.shiftId);
      }

      await _firestoreHelper.updateDocument(
        shiftCollection,
        shift.shiftId,
        shiftData,
      );

      return Right(shift.shiftId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to update shift: $e',
        ),
      );
    }
  }

  /// Deletes a shift from Firestore.
  Future<Either<Failure, String>> deleteShift(String shiftId) async {
    try {
      await _firestoreHelper.deleteDocument(shiftCollection, shiftId);
      return Right(shiftId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to delete shift: $e',
        ),
      );
    }
  }

  /// Query shifts by a given date
  Future<Either<Failure, List<ShiftModel>>> queryShiftsByDate(
    DateTime date,
  ) async {
    try {
      final snapshot = await _firestoreHelper.queryCollection(
        shiftCollection,
        field: 'startTime',
        filter: WhereFilter.greaterThanOrEqual,
        value: date,
      );

      final shifts = snapshot.docs
          .map((doc) => ShiftModel.fromSnapshot(doc.data()))
          .toList();
      return Right(shifts);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch shifts: $e',
        ),
      );
    }
  }

  /// Query shifts by a given dates
  Future<Either<Failure, List<ShiftModel>>> queryShiftsByDates(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final snapshot =
          await _firestoreHelper.queryCollectionWithMultipleFilters(
        scheduledShiftCollection,
        fields: ['startTime', 'endTime'],
        filters: [WhereFilter.greaterThanOrEqual, WhereFilter.lessThanOrEqual],
        values: [startDate, endDate],
      );

      final shifts = snapshot.docs
          .map((doc) => ShiftModel.fromSnapshot(doc.data()))
          .toList();

      return Right(shifts);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch shifts: $e',
        ),
      );
    }
  }

  /// Clocks in a caregiver for a shift.
  /// first fetch the shift by its ID
  /// then we update the shift, then notify care home
  Future<Either<Failure, String>> clockInCaregiver(
    String shiftId, {
    required String clockInTime,
    required Map<String, dynamic> clockInLocation,
  }) async {
    try {
      final date = DateTime.parse(clockInTime);

      final clockIn = DateTime(
        date.year,
        date.month,
        date.day,
        date.hour,
        date.minute,
      );
      final lat = clockInLocation['lat']! as double;
      final long = clockInLocation['long']! as double;

      final result1 = await getShift(
        shiftId,
        isSchduled: true,
      );

      if (result1.isLeft()) {
        final failure = result1.fold((l) => l, (r) => null);

        return Left(
          GevericFailure(
            errorMessage: failure!.errorMessage,
          ),
        );
      }

      // -- check if the shift is already clocked in i.e. status is inProgress
      final shift = result1.fold((l) => null, (r) => r);
      if (shift!.status == ShiftStatus.inProgress) {
        return Left(
          GevericFailure(
            errorMessage: 'Caregiver is already clocked in',
          ),
        );
      }

      // update the shift
      final clockedInShift = shift.copyWith(
        clockIn: Clock(
          time: clockIn,
          lat: lat,
          long: long,
        ),
        status: ShiftStatus.inProgress,
        updatedAt: DateTime.now(),
      );

      final result2 = await updateShift(clockedInShift, isSchduled: true);

      if (result2.isLeft()) {
        return result2;
      }

      // notify care home
      MessagingService(_messagingHelper, _firestoreHelper).send(
        'Caregiver Clocked In',
        'Caregiver has clocked in for the shift',
        userId: shift.careHomeId,
      );

      return const Right('Caregiver clocked in successfully');
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to clock in caregiver: $e',
        ),
      );
    }
  }

  /// Clocks out a caregiver for a shift.
  /// first fetch the shift by its ID
  /// then we update the shift, then notify care home
  Future<Either<Failure, String>> clockOutCaregiver(
    String shiftId, {
    required String clockOutTime,
    required Map<String, dynamic> clockOutLocation,
  }) async {
    try {
      final date = DateTime.parse(clockOutTime);

      final clockOut = DateTime(
        date.year,
        date.month,
        date.day,
        date.hour,
        date.minute,
      );
      
      final lat = clockOutLocation['lat']! as double;
      final long = clockOutLocation['long']! as double;

      final result1 = await getShift(
        shiftId,
        isSchduled: true,
      );

      if (result1.isLeft()) {
        final failure = result1.fold((l) => l, (r) => null);

        return Left(
          GevericFailure(
            errorMessage: failure!.errorMessage,
          ),
        );
      }

      // -- check if the shift is already clocked out i.e. status is completed
      final shift = result1.fold((l) => null, (r) => r);
      if (shift!.status == ShiftStatus.completed) {
        return Left(
          GevericFailure(
            errorMessage: 'Caregiver is already clocked out',
          ),
        );
      }

      // update the shift
      final clockedOutShift = shift.copyWith(
        clockOut: Clock(
          time: clockOut,
          lat: lat,
          long: long,
        ),
        status: ShiftStatus.completed,
        updatedAt: DateTime.now(),
      );

      final result2 = await updateShift(
        clockedOutShift,
        isSchduled: true,
      );
      if (result2.isLeft()) {
        return result2;
      }

      // notify care home
      MessagingService(_messagingHelper, _firestoreHelper).send(
        'Caregiver Clocked Out',
        'Caregiver has clocked out for the shift',
        userId: shift.careHomeId,
      );

      return const Right('Caregiver clocked out successfully');
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to clock out caregiver: $e',
        ),
      );
    }
  }
}
