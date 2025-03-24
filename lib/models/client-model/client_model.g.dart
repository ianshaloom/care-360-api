// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientModel _$ClientModelFromJson(Map<String, dynamic> json) => ClientModel(
      clientId: json['clientId'] as String,
      name: json['name'] as String,
      age: (json['age'] as num).toInt(),
      location: json['location'] as String,
      coordinates: (json['coordinates'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      medicalHistory: json['medicalHistory'] as String,
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

Map<String, dynamic> _$ClientModelToJson(ClientModel instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'name': instance.name,
      'age': instance.age,
      'location': instance.location,
      'coordinates': instance.coordinates,
      'medicalHistory': instance.medicalHistory,
      'carePlan': instance.carePlan,
      'assignedCaregivers': instance.assignedCaregivers,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
