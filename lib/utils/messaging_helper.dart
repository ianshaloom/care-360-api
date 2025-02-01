import 'package:dart_firebase_admin/messaging.dart';

/// A service class for sending notifications to users.
class MessagingHelper {
  /// NotificationHelper constructor.
  MessagingHelper(this._messaging);

  /// Firebase Messaging instance.
  final Messaging _messaging;

  /// Sends a notification to a user.
  Future<void> sendNotification(
    String token,
    String title,
    String body, {
    Map<String, String>? notificationData,
  }) async {
    await _messaging.send(
      TokenMessage(
        token: token,
        notification: Notification(
          title: title,
          body: body,
        ),
        data: notificationData,
      ),
    );
  }

  /// Sends a notification to multiple users.
  Future<BatchResponse> sendMulticastNotification(
    List<String> tokens,
    String title,
    String body, {
    Map<String, String>? notificationData,
  }) async {
    final batchResponse = await _messaging.sendEach(
      tokens
          .map(
            (token) => TokenMessage(
              token: token,
              notification: Notification(
                title: title,
                body: body,
              ),
              data: notificationData,
            ),
          )
          .toList(),
    );

    return batchResponse;
  }
}
