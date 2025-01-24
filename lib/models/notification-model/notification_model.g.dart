// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      notificationId: json['notificationId'] as String,
      uid: json['uid'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      read: json['read'] as bool,
      relatedEntityId: json['relatedEntityId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'uid': instance.uid,
      'message': instance.message,
      'type': instance.type,
      'read': instance.read,
      'relatedEntityId': instance.relatedEntityId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
