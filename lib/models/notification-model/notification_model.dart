import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

/// NotificationModel class
/// Represents a notification sent to a user in the system.
@JsonSerializable()
class NotificationModel {
  /// Constructor for [NotificationModel]
  NotificationModel({
    required this.notificationId,
    required this.uid,
    required this.message,
    required this.type,
    required this.read,
    required this.createdAt,
  });

  /// Static function to create an empty [NotificationModel]
  NotificationModel.empty()
      : notificationId = '',
        uid = '',
        message = '',
        type = '',
        read = false,
        createdAt = DateTime.now();

  /// Static function to create [NotificationModel] from a Firestore snapshot
  factory NotificationModel.fromSnapshot(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  /// Convert [NotificationModel] to a Firestore-compatible map
  Map<String, dynamic> toSnapshot() => _$NotificationModelToJson(this);

  /// Unique identifier for the notification
  final String notificationId;

  /// Firebase Authentication UID of the user receiving the notification
  final String uid;

  /// Content of the notification message
  final String message;

  /// Type of notification (e.g., "shift_update", "request", "alert")
  final String type;

  /// Indicates whether the notification has been read
  final bool read;

  /// Timestamp when the notification was created
  final DateTime createdAt;

  /// Override toString method for better logging and debugging
  @override
  String toString() {
    return 'NotificationModel{notificationId: $notificationId, uid: $uid,'
        ' message: $message, type: $type, read: $read, createdAt: $createdAt}';
  }
}
