// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationTokenModel _$NotificationTokenModelFromJson(
        Map<String, dynamic> json) =>
    NotificationTokenModel(
      id: json['id'] as String,
      token: json['token'] as String,
      role: json['role'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$NotificationTokenModelToJson(
  NotificationTokenModel instance,
) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'role': instance.role,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND
