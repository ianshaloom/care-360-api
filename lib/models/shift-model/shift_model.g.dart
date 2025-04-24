// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// JsonSerializableGenerator
ShiftModel _$ShiftModelFromJson(Map<String, dynamic> json) => ShiftModel(
      shiftId: json['shiftId'] as String,
      requestId: json['requestId'] as String,
      caregiverId: json['caregiverId'] as String,
      clientId: json['clientId'] as String,
      clientType:  json['clientType'] as String,
      status: $enumDecode(_$ShiftStatusEnumMap, json['status']),
      floatStatus: $enumDecode(_$FloatStatusEnumMap, json['floatStatus']),
      notes: (json['notes'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, e as String),
      ),
      clockIn: json['clockIn'] != null
          ? Clock.fromSnapshot(json['clockIn'] as Map<String, dynamic>)
          : null,
      clockOut: json['clockOut'] != null
          ? Clock.fromSnapshot(json['clockOut'] as Map<String, dynamic>)
          : null,
      clientDetails: ClientDetails.fromSnapshot(
        json['clientDetails'] as Map<String, dynamic>,
      ),
      startTime: (json['startTime'] as Timestamp).toDateTime(),
      endTime: (json['endTime'] as Timestamp).toDateTime(),
      createdAt: (json['createdAt'] as Timestamp).toDateTime(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDateTime()
          : null,
    );

/// This is the JSON representation of a [ShiftModel] object.
/// Used during serialization of a [ShiftModel] object to a JSON object
/// that is compatible with Firestore.
Map<String, dynamic> _$ShiftModelToDoc(ShiftModel instance) =>
    <String, dynamic>{
      'shiftId': instance.shiftId,
      'requestId': instance.requestId,
      'caregiverId': instance.caregiverId,
      'clientId': instance.clientId,
      'clientType': instance.clientType,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'status': _$ShiftStatusEnumMap[instance.status],
      'floatStatus': _$FloatStatusEnumMap[instance.floatStatus],
      'notes': instance.notes,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'clientDetails': instance.clientDetails.toJson(),
      'clockIn': instance.clockIn?.toDoc(),
      'clockOut': instance.clockOut?.toDoc(),
    };

/// This is the JSON representation of a [ShiftModel] object.
/// Used in HTTP requests and responses.
Map<String, dynamic> _$ShiftModelToJson(ShiftModel instance) =>
    <String, dynamic>{
      'shiftId': instance.shiftId,
      'requestId': instance.requestId,
      'caregiverId': instance.caregiverId,
      'clientId': instance.clientId,
      'clientType': instance.clientType,
      'status': _$ShiftStatusEnumMap[instance.status],
      'floatStatus': _$FloatStatusEnumMap[instance.floatStatus],
      'notes': instance.notes,
      'clockIn': instance.clockIn?.toJson(),
      'clockOut': instance.clockOut?.toJson(),
      'clientDetails': instance.clientDetails.toJson(),
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
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
