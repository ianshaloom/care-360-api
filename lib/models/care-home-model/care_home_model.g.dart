// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_home_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CareHomeModel _$CareHomeModelFromJson(Map<String, dynamic> json) =>
    CareHomeModel(
      careHomeId: json['careHomeId'] as String,
      uid: json['uid'] as String,
      fullname: json['fullname'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      requests:
          (json['requests'] as List<dynamic>).map((e) => e as String).toList(),
      profileImage: json['profileImage'] as String?,
      notificationToken: json['notificationToken'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDateTime(),
      updatedAt: json['updatedAt'] == null
          ? null
          : (json['updatedAt'] as Timestamp).toDateTime(),
    );

Map<String, dynamic> _$CareHomeModelToJson(CareHomeModel instance) =>
    <String, dynamic>{
      'careHomeId': instance.careHomeId,
      'uid': instance.uid,
      'fullname': instance.fullname,
      'email': instance.email,
      'address': instance.address,
      'phone': instance.phone,
      'profileImage': instance.profileImage,
      'notificationToken': instance.notificationToken,
      'requests': instance.requests,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

Map<String, dynamic> _$CareHomeModelToDoc(CareHomeModel instance) =>
    <String, dynamic>{
      'careHomeId': instance.careHomeId,
      'uid': instance.uid,
      'fullname': instance.fullname,
      'email': instance.email,
      'address': instance.address,
      'phone': instance.phone,
      'profileImage': instance.profileImage,
      'notificationToken': instance.notificationToken,
      'requests': instance.requests,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
