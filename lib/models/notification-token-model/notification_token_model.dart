import 'package:json_annotation/json_annotation.dart';

part 'notification_token_model.g.dart';

/// NotificationTokenModel class
@JsonSerializable()
class NotificationTokenModel {
  /// Constructor for [NotificationTokenModel]
  NotificationTokenModel({
    required this.id,
    required this.token,
    required this.role,
    required this.updatedAt,
  });

  /// Static function to create empty [NotificationTokenModel]
  NotificationTokenModel.empty()
      : id = '',
        token = '',
        role = '',
        updatedAt = DateTime.now();

  /// Static function to create [NotificationTokenModel] from a map
  factory NotificationTokenModel.fromSnapshot(Map<String, dynamic> json) =>
      _$NotificationTokenModelFromJson(json);

  /// Convert [NotificationTokenModel] to a map
  Map<String, dynamic> toSnapshot() => _$NotificationTokenModelToJson(this);

  /// user ID
  final String id;

  /// the token
  final String token;

  /// user role
  final String role;

  /// time of update
  final DateTime updatedAt;

  /// override toString method
  @override
  String toString() {
    return 'ActivationModel{id: $id, code: $token, isUsed: $role,'
        ' updatedAt: $updatedAt}';
        
  }
}
