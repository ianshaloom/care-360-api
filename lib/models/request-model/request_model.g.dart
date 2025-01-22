// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestModel _$RequestModelFromJson(Map<String, dynamic> json) => RequestModel(
      requestId: json['requestId'] as String,
      careHomeId: json['careHomeId'] as String,
      clientId: json['clientId'] as String,
      status: json['status'] as String,
      careRequirements: json['careRequirements'] as String,
      shiftStartTime: DateTime.parse(json['shiftStartTime'] as String),
      shiftEndTime: DateTime.parse(json['shiftEndTime'] as String),
      additionalNotes: json['additionalNotes'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      assignedCaregiverId: json['assignedCaregiverId'] as String?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$RequestModelToJson(RequestModel instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'careHomeId': instance.careHomeId,
      'clientId': instance.clientId,
      'status': instance.status,
      'careRequirements': instance.careRequirements,
      'shiftStartTime': instance.shiftStartTime.toIso8601String(),
      'shiftEndTime': instance.shiftEndTime.toIso8601String(),
      'additionalNotes': instance.additionalNotes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'assignedCaregiverId': instance.assignedCaregiverId,
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };
