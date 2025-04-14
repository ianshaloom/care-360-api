import 'package:care360/constants/constants.dart';
import 'package:care360/utils/helpers/firestore_helper.dart';
import 'package:care360/utils/helpers/messaging_helper.dart';
import 'package:dart_firebase_admin/messaging.dart';

/// Service class for managing messaging-related operations.
class MessagingService {
  /// Constructor for [MessagingService].
  MessagingService(this._messagingHelper, this._firestoreHelper);

  final MessagingHelper _messagingHelper;
  final FirestoreHelper _firestoreHelper;

  /// Fetch a token of a user from a Firestore collection.
  Future<String?> getToken(
    String id,
  ) async {
    final snapshot = await _firestoreHelper.getDocument(
      notifTokenCollection,
      id,
    );

    if (snapshot.containsKey('token')) {
      return snapshot['token'] as String?;
    }

    return null;
  }

  /// Fetches all tokens from a Firestore collection.
  Future<List<String>> getTokens(
    String user,
  ) async {
    final snapshot = await _firestoreHelper.queryCollection(
      notifTokenCollection,
      field: 'user',
      value: user,
    );

    final users = snapshot.docs.map((doc) => doc.data()).toList();

    final tokens = <String>[];

    // skip where notificationToken is null, add the rest to tokens
    for (final user in users) {
      if (user.containsKey('token')) {
        if (user['token'] != null) {
          tokens.add(user['token']! as String);
        }
      }
    }

    return tokens;
  }

  /// Sends a notification to a single device.
  Future<void> send(
    String title,
    String body, {
    String? userId,
    String? notifToken,
    Map<String, String>? notificationData,
  }) async {
    try {
      // send notification to a specific token
      if (notifToken != null) {
        await _messagingHelper.sendNotification(
          notifToken,
          title,
          body,
          notificationData: notificationData,
        );

        return;
      }

      // get token
      final token = await getToken(userId!);

      if (token == null) {
        // log error
        await _firestoreHelper.addDocument(
          logCollection,
          {
            'id': 'notification-log',
            'token': 'Not found',
            'error': 'Token not found',
          },
          documentId: DateTime.now().toIso8601String(),
        );

        return;
      }

      // else send notification
      await _messagingHelper.sendNotification(
        token,
        title,
        body,
        notificationData: notificationData,
      );

      return;
    } on FirebaseMessagingAdminException catch (e) {
      // log error
      await _firestoreHelper.addDocument(
        logCollection,
        {
          'id': 'notification-log',
          'token': token,
          'error': e.message,
        },
        documentId: DateTime.now().toIso8601String(),
      );

      return;
    } catch (e) {
      return;
    }
  }

  /// Sends a notification to several devices.
  Future<void> multicast(
    String title,
    String body, {
    String? user,
    List<String>? notifTokens,
    Map<String, String>? notificationData,
  }) async {
    try {
      // send notification to specific tokens
      if (notifTokens != null) {
        await sendBatchNotif(
          title,
          body,
          notifTokens: notifTokens,
          notificationData: notificationData,
        );

        return;
      }

      // get tokens
      final tokens = await getTokens(user!);

      if (tokens.isEmpty) {
        // log error
        await _firestoreHelper.addDocument(
          logCollection,
          {
            'id': 'notification-log',
            'tokens': 'Not found',
            'error': 'No tokens found',
          },
          documentId: DateTime.now().toIso8601String(),
        );

        return;
      }

      // else send notification
      await sendBatchNotif(
        title,
        body,
        notifTokens: tokens,
        notificationData: notificationData,
      );

      return;
    } catch (e) {
      return;
    }
  }

  /// Sends a notification to a multiple devices.
  Future<String> sendBatchNotif(
    String title,
    String body, {
    required List<String> notifTokens,
    Map<String, String>? notificationData,
  }) async {
    final batchResponse = await _messagingHelper.sendMulticastNotification(
      notifTokens,
      title,
      body,
      notificationData: notificationData,
    );

    final failed = batchResponse.responses
        .where((response) => !response.success)
        .map((response) => response.error!.message)
        .toList();

    /// If there are any failed notifications, log them to firestore.
    if (failed.isNotEmpty) {
      final data = {
        'id': 'notification-log',
        'tokens': notifTokens.length,
        'failed': failed.length,
        'failedTokens': failed,
      };
      await _firestoreHelper.addDocument(
        logCollection,
        data,
        documentId: DateTime.now().toIso8601String(),
      );

      return 'Notification sent to ${notifTokens.length} devices';
    }

    return 'Notification sent to ${notifTokens.length} devices';
  }
}
