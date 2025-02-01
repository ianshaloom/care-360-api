import 'package:care360/constants/constants.dart';
import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/models/notification-model/notification_model.dart';
import 'package:care360/utils/firestore_helper.dart';
import 'package:dartz/dartz.dart';

/// Service class for managing notification-related operations.
class NotificationService {
  /// Constructor for [NotificationService].
  NotificationService(this._firestoreHelper);

  final FirestoreHelper _firestoreHelper;

  /// Fetches a notification by their unique ID.
  Future<Either<Failure, NotificationModel>> getNotification(
    String notificationId,
  ) async {
    try {
      final snapshot = await _firestoreHelper.getDocument(
        notificationCollection,
        notificationId,
      );
      if (snapshot.isEmpty) {
        throw Exception('Notification not found');
      }
      return Right(NotificationModel.fromSnapshot(snapshot));
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch notification: $e',
        ),
      );
    }
  }

  /// Fetches all notifications from Firestore.
  Future<Either<Failure, List<NotificationModel>>> getAllNotifications() async {
    try {
      final snapshot =
          await _firestoreHelper.getCollection(notificationCollection);

      final notifications = snapshot.docs
          .map((doc) => NotificationModel.fromSnapshot(doc.data()))
          .toList();
      return Right(notifications);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch notifications: $e',
        ),
      );
    }
  }

  /// Creates a new notification in Firestore.
  Future<Either<Failure, String>> createNotification(
    NotificationModel notification,
  ) async {
    try {
      final notificationData = notification.toSnapshot();
      final notificationId = await _firestoreHelper.addDocument(
        notificationCollection,
        notificationData,
        documentId: notification.notificationId,
      );
      return Right(notificationId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to create notification: $e',
        ),
      );
    }
  }

  /// Updates an existing notification in Firestore.
  Future<Either<Failure, String>> updateNotification(
    NotificationModel notification,
  ) async {
    try {
      final notificationData = notification.toSnapshot();

      await _firestoreHelper.updateDocument(
        notificationCollection,
        notification.notificationId,
        notificationData,
      );

      return Right(notification.notificationId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to update notification: $e',
        ),
      );
    }
  }

  /// Deletes a notification from Firestore.
  Future<Either<Failure, String>> deleteNotification(
    String notificationId,
  ) async {
    try {
      await _firestoreHelper.deleteDocument(
        notificationCollection,
        notificationId,
      );
      return Right(notificationId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to delete notification: $e',
        ),
      );
    }
  }
}
