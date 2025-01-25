import 'package:care360/constants/constants.dart';
import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/models/care-giver-model/care_giver_model.dart';
import 'package:care360/utils/firestore_helper.dart';
import 'package:dartz/dartz.dart';

/// Service class for managing caregiver-related operations.
class CaregiverService {
  /// Constructor for [CaregiverService].
  CaregiverService(this._firestoreHelper);

  final FirestoreHelper _firestoreHelper;

  /// Fetches a caregiver by their unique ID.
  Future<Either<Failure, CaregiverModel>> getCaregiver(
    String caregiverId,
  ) async {
    try {
      final snapshot =
          await _firestoreHelper.getDocument(caregiverCollection, caregiverId);
      if (snapshot.isEmpty) {
        throw Exception('Caregiver not found');
      }
      return Right(CaregiverModel.fromSnapshot(snapshot));
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch caregiver: $e',
        ),
      );
    }
  }

  /// Fetches all caregivers from Firestore.
  Future<Either<Failure, List<CaregiverModel>>> getAllCaregivers() async {
    try {
      final snapshot =
          await _firestoreHelper.getCollection(caregiverCollection);

      final caregivers = snapshot.docs
          .map((doc) => CaregiverModel.fromSnapshot(doc.data()))
          .toList();
      return Right(caregivers);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch caregivers: $e',
        ),
      );
    }
  }

  /// Creates a new caregiver in Firestore.
  Future<Either<Failure, String>> createCaregiver(
    CaregiverModel caregiver,
  ) async {
    try {
      final caregiverData = caregiver.toSnapshot();
      final caregiverId = await _firestoreHelper.addDocument(
        caregiverCollection,
        caregiverData,
        documentId: caregiver.caregiverId,
      );
      return Right(caregiverId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to create caregiver: $e',
        ),
      );
    }
  }

  /// Updates an existing caregiver in Firestore.
  Future<Either<Failure, String>> updateCaregiver(
    CaregiverModel caregiver,
  ) async {
    try {
      final caregiverData = caregiver.toSnapshot();

      await _firestoreHelper.updateDocument(
        caregiverCollection,
        caregiver.caregiverId,
        caregiverData,
      );

      return Right(caregiver.caregiverId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to update caregiver: $e',
        ),
      );
    }
  }

  /// Deletes a caregiver from Firestore.
  Future<Either<Failure, String>> deleteCaregiver(String caregiverId) async {
    try {
      await _firestoreHelper.deleteDocument(caregiverCollection, caregiverId);
      return Right(caregiverId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to delete caregiver: $e',
        ),
      );
    }
  }
}
