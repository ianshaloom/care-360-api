// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_home_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CareHomeModel _$CareHomeModelFromJson(Map<String, dynamic> json) =>
    CareHomeModel(
      careHomeId: json['careHomeId'] as String,
      uid: json['uid'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      requests:
          (json['requests'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CareHomeModelToJson(CareHomeModel instance) =>
    <String, dynamic>{
      'careHomeId': instance.careHomeId,
      'uid': instance.uid,
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
      'requests': instance.requests,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
