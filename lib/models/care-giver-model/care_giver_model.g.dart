// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_giver_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CaregiverModel _$CaregiverModelFromJson(Map<String, dynamic> json) =>
    CaregiverModel(
      caregiverId: json['caregiverId'] as String,
      uid: json['uid'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      qualifications: (json['qualifications'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      availability: (json['availability'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      assignedShifts: (json['assignedShifts'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      registeredCode: json['registeredCode'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CaregiverModelToJson(CaregiverModel instance) =>
    <String, dynamic>{
      'caregiverId': instance.caregiverId,
      'uid': instance.uid,
      'name': instance.name,
      'phone': instance.phone,
      'qualifications': instance.qualifications,
      'availability': instance.availability,
      'assignedShifts': instance.assignedShifts,
      'registeredCode': instance.registeredCode,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
