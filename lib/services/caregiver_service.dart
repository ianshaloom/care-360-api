import 'package:care360/constants/constants.dart';
import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/models/care-giver-model/care_giver_model.dart';
import 'package:care360/utils/helpers/firestore_helper.dart';
import 'package:dartz/dartz.dart';

/// Service class for managing caregiver-related operations.
class CareGiverService {
  /// Constructor for [CareGiverService].
  CareGiverService(this._firestoreHelper);

  final FirestoreHelper _firestoreHelper;

  /// Fetches a caregiver by their unique ID.
  Future<Either<Failure, CareGiverModel>> getCaregiver(
    String caregiverId,
  ) async {
    try {
      final snapshot =
          await _firestoreHelper.getDocument(caregiverCollection, caregiverId);
      if (snapshot.isEmpty) {
        throw Exception('Caregiver not found');
      }
      return Right(CareGiverModel.fromSnapshot(snapshot));
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch caregiver: $e',
        ),
      );
    }
  }

  /// Fetches all caregivers from Firestore.
  Future<Either<Failure, List<CareGiverModel>>> getAllCaregivers() async {
    try {
      final snapshot =
          await _firestoreHelper.getCollection(caregiverCollection);

      final caregivers = snapshot.docs
          .map((doc) => CareGiverModel.fromSnapshot(doc.data()))
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
    CareGiverModel caregiver,
  ) async {
    try {
      final caregiverData = caregiver.toDoc();

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
    CareGiverModel caregiver,
  ) async {
    try {
      final caregiverData = caregiver.toJson();

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
