// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domiciliary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DomiciliaryModel _$DomiciliaryModelFromJson(Map<String, dynamic> json) =>
    DomiciliaryModel(
      clientId: json['clientId'] as String,
      name: json['name'] as String,
      age: (json['age'] as num).toInt(),
      location: json['location'] as String,
      geopoint:json['geopoint'] as GeoPoint,
      medicalHistory: (json['medicalHistory'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      carePlan: json['carePlan'] as String,
      assignedCaregivers: (json['assignedCaregivers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DomiciliaryModelToJson(DomiciliaryModel instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'name': instance.name,
      'age': instance.age,
      'location': instance.location,
      'geopoint': instance.geopoint,
      'medicalHistory': instance.medicalHistory,
      'carePlan': instance.carePlan,
      'assignedCaregivers': instance.assignedCaregivers,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
