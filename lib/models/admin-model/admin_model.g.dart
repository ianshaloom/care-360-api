// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminModel _$AdminModelFromJson(Map<String, dynamic> json) => AdminModel(
      uid: json['uid'] as String,
      fullname: json['fullname'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      profileImage: json['profileImage'] as String?,
      notificationToken: json['notificationToken'] as String?,
      role: json['role'] as String? ?? 'user',
      createdAt: (json['createdAt'] as Timestamp).toDateTime(),
      updatedAt: json['updatedAt'] == null
          ? null
          : (json['updatedAt'] as Timestamp).toDateTime(),
    );

Map<String, dynamic> _$AdminModelToJson(AdminModel instance) =>
    <String, dynamic>{
      'role': instance.role,
      'uid': instance.uid,
      'fullname': instance.fullname,
      'email': instance.email,
      'phone': instance.phone,
      'profileImage': instance.profileImage,
      'notificationToken': instance.notificationToken,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

Map<String, dynamic> _$AdminModelToDoc(AdminModel instance) =>
    <String, dynamic>{
      'role': instance.role,
      'uid': instance.uid,
      'fullname': instance.fullname,
      'email': instance.email,
      'phone': instance.phone,
      'profileImage': instance.profileImage,
      'notificationToken': instance.notificationToken,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
