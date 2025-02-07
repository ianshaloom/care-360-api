// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_giver_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CareGiverModel _$CareGiverModelFromJson(Map<String, dynamic> json) =>
    CareGiverModel(
      address: json['address'] as String,
      uid: json['uid'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      profileImage: json['profileImage'] as String?,
      notificationToken: json['notificationToken'] as String?,
      caregiverId: json['caregiverId'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      qualifications: (json['qualifications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      preferredCareTypes: (json['preferredCareTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      availability: (json['availability'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      assignedShifts: (json['assignedShifts'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isAvailable: json['isAvailable'] as bool? ?? true,
      registeredCode: json['registeredCode'] as String? ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDateTime(),
      updatedAt: json['updatedAt'] == null
          ? null
          : (json['updatedAt'] as Timestamp).toDateTime(),
    );

Map<String, dynamic> _$CareGiverModelToJson(CareGiverModel instance) =>
    <String, dynamic>{
      'caregiverId': instance.caregiverId,
      'uid': instance.uid,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'profileImage': instance.profileImage,
      'notificationToken': instance.notificationToken,
      'qualifications': instance.qualifications,
      'preferredCareTypes': instance.preferredCareTypes,
      'availability': instance.availability,
      'assignedShifts': instance.assignedShifts,
      'registeredCode': instance.registeredCode,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isAvailable': instance.isAvailable,
    };

Map<String, dynamic> _$CareGiverModelToDoc(CareGiverModel instance) =>
    <String, dynamic>{
      'caregiverId': instance.caregiverId,
      'uid': instance.uid,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'profileImage': instance.profileImage,
      'notificationToken': instance.notificationToken,
      'qualifications': instance.qualifications,
      'preferredCareTypes': instance.preferredCareTypes,
      'availability': instance.availability,
      'assignedShifts': instance.assignedShifts,
      'registeredCode': instance.registeredCode,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'isAvailable': instance.isAvailable,
    };
