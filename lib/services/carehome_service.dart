import 'package:care360/constants/constants.dart';
import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/models/care-home-model/care_home_model.dart';
import 'package:care360/utils/helpers/firestore_helper.dart';
import 'package:dartz/dartz.dart';

/// Service class for managing care home-related operations.
class CareHomeService {
  /// Constructor for [CareHomeService].
  CareHomeService(this._firestoreHelper);

  final FirestoreHelper _firestoreHelper;

  /// Fetches a care home by its unique ID.
  Future<Either<Failure, CareHomeModel>> getCareHome(
    String careHomeId,
  ) async {
    try {
      final snapshot =
          await _firestoreHelper.getDocument(careHomeCollection, careHomeId);
      if (snapshot.isEmpty) {
        throw Exception('Care home not found');
      }
      return Right(CareHomeModel.fromSnapshot(snapshot));
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch care home: $e',
        ),
      );
    }
  }

  /// Fetches all care homes from Firestore.
  Future<Either<Failure, List<CareHomeModel>>> getAllCareHomes() async {
    try {
      final snapshot = await _firestoreHelper.getCollection(careHomeCollection);

      final careHomes = snapshot.docs
          .map((doc) => CareHomeModel.fromSnapshot(doc.data()))
          .toList();
      return Right(careHomes);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch care homes: $e',
        ),
      );
    }
  }

  /// Creates a new care home in Firestore.
  Future<Either<Failure, String>> createCareHome(
    CareHomeModel careHome,
  ) async {
    try {
      final careHomeData = careHome.toDoc();
      final careHomeId = await _firestoreHelper.addDocument(
        careHomeCollection,
        careHomeData,
        documentId: careHome.careHomeId,
      );
      return Right(careHomeId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to create care home: $e',
        ),
      );
    }
  }

  /// Updates an existing care home in Firestore.
  Future<Either<Failure, String>> updateCareHome(
    CareHomeModel careHome,
  ) async {
    try {
      final careHomeData = careHome.toJson();

      await _firestoreHelper.updateDocument(
        careHomeCollection,
        careHome.careHomeId,
        careHomeData,
      );

      return Right(careHome.careHomeId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to update care home: $e',
        ),
      );
    }
  }

  /// Deletes a care home from Firestore.
  Future<Either<Failure, String>> deleteCareHome(String careHomeId) async {
    try {
      await _firestoreHelper.deleteDocument(careHomeCollection, careHomeId);
      return Right(careHomeId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to delete care home: $e',
        ),
      );
    }
  }
}
