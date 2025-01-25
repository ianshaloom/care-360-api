import 'package:care360/data/firestore_ds.dart';
import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/errors/firestore_exceptions.dart';
import 'package:care360/models/activation-model/activation_model.dart';
import 'package:dartz/dartz.dart';

/// KaisaAbsImpl class
class Care360Repository {
  ///  Care360Repository constructor
  Care360Repository(this.firestoreDs);

  /// FirestoreDs instance
  final FirestoreDs firestoreDs;

  ///  Function to generate a random code
  Future<Either<Failure, String>> postActivation(String id) async {
    try {
      // A new activation code model from the id
      final activation = ActivationModel(
        id: id,
        code: generateActivationCode(),
        isUsed: false,
        createdAt: DateTime.now(),
        // updatedAt: DateTime.now(),
        // usedAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 1)),
      );

      // Set the activation code to the firestore
      await firestoreDs.setActivation(activation.toSnapshot());

      return const Right('Success');
    } on FireDartSetException catch (e) {
      return Left(
        FirestoreFailure(errorMessage: e.message),
      );
    } catch (e) {
      return Left(
        FirestoreFailure(errorMessage: e.toString()),
      );
    }
  }

  /// Function to get the activation code
  Future<Either<Failure, Map<String, dynamic>>> getActivation(String id) async {
    try {
      final activation = await firestoreDs.getActivation(id);

      return Right(activation);
    } on FireDartGetException catch (e) {
      return Left(
        FirestoreFailure(errorMessage: e.message),
      );
    } catch (e) {
      return Left(
        FirestoreFailure(errorMessage: e.toString()),
      );
    }
  }

  /// Function to update the activation code
  Future<Either<Failure, String>> updateActivation(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await firestoreDs.updateActivation(data);

      return Right(result);
    } on FireDartUpdateException catch (e) {
      return Left(
        FirestoreFailure(errorMessage: e.message),
      );
    } catch (e) {
      return Left(
        FirestoreFailure(errorMessage: e.toString()),
      );
    }
  }
}
