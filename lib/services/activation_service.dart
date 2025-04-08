import 'package:care360/constants/constants.dart';
import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/models/activation-model/activation_model.dart';
import 'package:care360/utils/helpers/firestore_helper.dart';
import 'package:dartz/dartz.dart';

/// Service class for managing caregiver-related operations.
class ActivationService {
  /// Constructor for [ActivationService].
  ActivationService(this._firestoreHelper);

  final FirestoreHelper _firestoreHelper;

  /// Fetches a activation by their unique ID.
  Future<Either<Failure, ActivationModel>> getActivation(
    String id,
  ) async {
    try {
      final snapshot =
          await _firestoreHelper.getDocument(activationCollection, id);
      if (snapshot.isEmpty) {
        throw Exception('Activation not found');
      }

      return Right(ActivationModel.fromSnapshot(snapshot));
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch activation: $e',
        ),
      );
    }
  }

  /// Fetches all activations from Firestore.
  Future<Either<Failure, List<ActivationModel>>> getAllActivations() async {
    try {
      final snapshot =
          await _firestoreHelper.getCollection(activationCollection);

      final activations = snapshot.docs
          .map((doc) => ActivationModel.fromSnapshot(doc.data()))
          .toList();
      return Right(activations);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch activations: $e',
        ),
      );
    }
  }

  /// Creates a new activation in Firestore.
  Future<Either<Failure, String>> createActivation(String email) async {
    try {
      // A new activation code model from the id
      final activation = ActivationModel(
        id: email,
        code: generateActivationCode(),
        isUsed: false,
        createdAt: DateTime.now(),
        // updatedAt: DateTime.now(),
        // usedAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 1)),
      );

      final activationData = activation.toSnapshot();

      final activationId = await _firestoreHelper.addDocument(
        activationCollection,
        activationData,
        documentId: activation.id,
      );

      return Right(activationId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to create activation: $e',
        ),
      );
    }
  }

  /// Updates an existing activation in Firestore.
  Future<Either<Failure, String>> updateActivation(
    ActivationModel activation,
  ) async {
    try {
      final activationData = activation.toSnapshot();

      await _firestoreHelper.updateDocument(
        activationCollection,
        activation.id,
        activationData,
      );
      return Right(activation.id);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to update activation: $e',
        ),
      );
    }
  }

  /// Deletes a activation from Firestore.
  Future<Either<Failure, String>> deleteActivation(
    String id,
  ) async {
    try {
      await _firestoreHelper.deleteDocument(activationCollection, id);
      return Right(id);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to delete activation: $e',
        ),
      );
    }
  }
}
