import 'package:care360/constants/constants.dart';
import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/models/notification-token-model/notification_token_model.dart';
import 'package:care360/utils/helpers/firestore_helper.dart';
import 'package:dartz/dartz.dart';

/// Service class for managing customer-related operations.
class NotificationTokenService {
  /// Constructor for [NotificationTokenService].
  NotificationTokenService(this._firestoreHelper);

  final FirestoreHelper _firestoreHelper;

  /// Fetches a [NotificationTokenModel] by their unique ID.
  Future<Either<Failure, NotificationTokenModel>> getNotifTokienById(
    String id,
  ) async {
    try {
      final snapshot =
          await _firestoreHelper.getDocument(notifTokenCollection, id);
      if (snapshot.isEmpty) {
        throw Exception('notification token doc not found');
      }
      return Right(NotificationTokenModel.fromSnapshot(snapshot));
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch token doc: $e',
        ),
      );
    }
  }

  /// Fetches all [NotificationTokenModel] from Firestore.
  Future<Either<Failure, List<NotificationTokenModel>>>
      getAllNotifTokens() async {
    try {
      final snapshot =
          await _firestoreHelper.getCollection(notifTokenCollection);

      final tokens = snapshot.docs
          .map((doc) => NotificationTokenModel.fromSnapshot(doc.data()))
          .toList();
      return Right(tokens);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch tokens docs: $e',
        ),
      );
    }
  }

  /// Creates a new [NotificationTokenModel] in Firestore.
  Future<Either<Failure, String>> persistNotifToken(
    NotificationTokenModel token,
  ) async {
    try {
      final tokenData = token.toSnapshot();
      final id = await _firestoreHelper.addDocument(
        notifTokenCollection,
        tokenData,
        documentId: token.id,
      );
      return Right(' Persisted token doc {$id}');
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to persist token doc: $e',
        ),
      );
    }
  }

  /// Updates an existing [NotificationTokenModel] in Firestore.
  Future<Either<Failure, String>> updateNotifToken(
    NotificationTokenModel token,
  ) async {
    try {
      final customerData = token.toSnapshot();

      await _firestoreHelper.updateDocument(
        notifTokenCollection,
        token.id,
        customerData,
      );

      return Right('Updated token doc {$token}');
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to update token doc: $e',
        ),
      );
    }
  }

  /// Deletes a [NotificationTokenModel] from Firestore.
  Future<Either<Failure, String>> deleteNotifToken(String id) async {
    try {
      await _firestoreHelper.deleteDocument(notifTokenCollection, id);
      return Right('Deleted token doc {$id}');
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to delete token doc: $e',
        ),
      );
    }
  }
}
