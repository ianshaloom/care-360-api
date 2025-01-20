// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivationModel _$ActivationModelFromJson(Map<String, dynamic> json) =>
    ActivationModel(
      id: json['id'] as String,
      code: json['code'] as String,
      isUsed: json['isUsed'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      usedAt: json['usedAt'] == null
          ? null
          : DateTime.parse(json['usedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$ActivationModelToJson(ActivationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'isUsed': instance.isUsed,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'usedAt': instance.usedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };
