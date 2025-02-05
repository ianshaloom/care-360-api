// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// JsonSerializableGenerator
ShiftModel _$ShiftModelFromJson(Map<String, dynamic> json) => ShiftModel(
      shiftId: json['shiftId'] as String,
      caregiverId: json['caregiverId'] as String,
      clientId: json['clientId'] as String,
      careHomeId: json['careHomeId'] as String,
      status: $enumDecode(_$ShiftStatusEnumMap, json['status']),
      floatStatus: $enumDecode(_$FloatStatusEnumMap, json['floatStatus']),
      notes: (json['notes'] as List<dynamic>).map((e) => e as String).toList(),
      clockInLocation: (json['clockInLocation'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      clockOutLocation:
          (json['clockOutLocation'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      startTime: (json['startTime'] as Timestamp).toDateTime(),
      endTime: (json['endTime'] as Timestamp).toDateTime(),
      createdAt: (json['createdAt'] as Timestamp).toDateTime(),
      updatedAt: json['updatedAt'] == null
          ? null
          : (json['updatedAt'] as Timestamp).toDateTime(),
      clockInTime: json['clockInTime'] == null
          ? null
          : (json['clockInTime'] as Timestamp).toDateTime(),
      clockOutTime: json['clockOutTime'] == null
          ? null
          : (json['clockOutTime'] as Timestamp).toDateTime(),
    );

/// This is the JSON representation of a [ShiftModel] object.
/// Used during serialization of a [ShiftModel] object to a JSON object
/// that is compatible with Firestore.
Map<String, dynamic> _$ShiftModelToDoc(ShiftModel instance) =>
    <String, dynamic>{
      'shiftId': instance.shiftId,
      'caregiverId': instance.caregiverId,
      'clientId': instance.clientId,
      'careHomeId': instance.careHomeId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'status': _$ShiftStatusEnumMap[instance.status],
      'floatStatus': _$FloatStatusEnumMap[instance.floatStatus],
      'notes': instance.notes,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'clockInTime': instance.clockInTime,
      'clockOutTime': instance.clockOutTime,
      'clockInLocation': instance.clockInLocation,
      'clockOutLocation': instance.clockOutLocation,
    };

/// This is the JSON representation of a [ShiftModel] object.
/// Used in HTTP requests and responses.
Map<String, dynamic> _$ShiftModelToJson(ShiftModel instance) =>
    <String, dynamic>{
      'shiftId': instance.shiftId,
      'caregiverId': instance.caregiverId,
      'clientId': instance.clientId,
      'careHomeId': instance.careHomeId,
      'status': _$ShiftStatusEnumMap[instance.status],
      'floatStatus': _$FloatStatusEnumMap[instance.floatStatus],
      'notes': instance.notes,
      'clockInLocation': instance.clockInLocation,
      'clockOutLocation': instance.clockOutLocation,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'clockInTime': instance.clockInTime?.toIso8601String(),
      'clockOutTime': instance.clockOutTime?.toIso8601String(),
    };

const _$ShiftStatusEnumMap = {
  ShiftStatus.scheduled: 'scheduled',
  ShiftStatus.inProgress: 'in-progress',
  ShiftStatus.completed: 'completed',
  ShiftStatus.missed: 'missed',
  ShiftStatus.cancelled: 'cancelled',
};

const _$FloatStatusEnumMap = {
  FloatStatus.notFloated: 'not-floated',
  FloatStatus.floating: 'floating',
  FloatStatus.picked: 'picked',
};
