// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftModel _$ShiftModelFromJson(Map<String, dynamic> json) => ShiftModel(
      shiftId: json['shiftId'] as String,
      caregiverId: json['caregiverId'] as String,
      clientId: json['clientId'] as String,
      careHomeId: json['careHomeId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      status: json['status'] as String,
      notes: (json['notes'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      clockInTime: json['clockInTime'] == null
          ? null
          : DateTime.parse(json['clockInTime'] as String),
      clockOutTime: json['clockOutTime'] == null
          ? null
          : DateTime.parse(json['clockOutTime'] as String),
      clockInLocation: (json['clockInLocation'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      clockOutLocation:
          (json['clockOutLocation'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$ShiftModelToJson(ShiftModel instance) =>
    <String, dynamic>{
      'shiftId': instance.shiftId,
      'caregiverId': instance.caregiverId,
      'clientId': instance.clientId,
      'careHomeId': instance.careHomeId,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'status': instance.status,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'clockInTime': instance.clockInTime?.toIso8601String(),
      'clockOutTime': instance.clockOutTime?.toIso8601String(),
      'clockInLocation': instance.clockInLocation,
      'clockOutLocation': instance.clockOutLocation,
    };
