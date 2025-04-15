// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestModel _$RequestModelFromJson(Map<String, dynamic> json) => RequestModel(
      requestId: json['requestId'] as String,
      careHomeId: json['careHomeId'] as String,
      status: $enumDecode(_$RequestStatusEnumMap, json['status']),
      careRequirements: json['careRequirements'] as String,
      shiftStartTime: (json['shiftStartTime'] as Timestamp).toDateTime(),
      shiftEndTime: (json['shiftEndTime'] as Timestamp).toDateTime(),
      additionalNotes: json['additionalNotes'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDateTime(),
      updatedAt: json['updatedAt'] == null
          ? null
          : (json['updatedAt'] as Timestamp).toDateTime(),
      assignedCaregiverId: json['assignedCaregiverId'] as String?,
      expiresAt: json['expiresAt'] == null
          ? null
          : (json['expiresAt'] as Timestamp).toDateTime(),
      untilDate: json['untilDate'] == null
          ? null
          : (json['untilDate'] as Timestamp).toDateTime(),
      repeatType:
          $enumDecodeNullable(_$RepeatTypeEnumMap, json['repeatType']) ??
              RepeatType.none,
      repeatDays: (json['repeatDays'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      selectedDates: (json['selectedDates'] as List<dynamic>?)
          ?.map(_convertToDateTime)
          .toList(),
      careHome: CareHome.fromSnapshot(json['careHome'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RequestModelToJson(RequestModel instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'careHomeId': instance.careHomeId,
      'status': _$RequestStatusEnumMap[instance.status],
      'careRequirements': instance.careRequirements,
      'additionalNotes': instance.additionalNotes,
      'assignedCaregiverId': instance.assignedCaregiverId,
      'shiftStartTime': instance.shiftStartTime.toIso8601String(),
      'shiftEndTime': instance.shiftEndTime.toIso8601String(),
      'untilDate': instance.untilDate?.toIso8601String(),
      'selectedDates':
          instance.selectedDates?.map((e) => e.toIso8601String()).toList(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'repeatType': _$RepeatTypeEnumMap[instance.repeatType],
      'repeatDays': instance.repeatDays,
      'careHome': instance.careHome.toJson(),
    };

Map<String, dynamic> _$RequestModelToDoc(RequestModel instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'careHomeId': instance.careHomeId,
      'status': _$RequestStatusEnumMap[instance.status],
      'careRequirements': instance.careRequirements,
      'additionalNotes': instance.additionalNotes,
      'assignedCaregiverId': instance.assignedCaregiverId,
      'shiftStartTime': instance.shiftStartTime,
      'shiftEndTime': instance.shiftEndTime,
      'untilDate': instance.untilDate,
      'repeatType': _$RepeatTypeEnumMap[instance.repeatType],
      'repeatDays': instance.repeatDays,
      'selectedDates': instance.selectedDates?.map((e) => e).toList(),
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'expiresAt': instance.expiresAt,
      'careHome': instance.careHome.toJson(),
    };

const _$RequestStatusEnumMap = {
  RequestStatus.open: 'open',
  RequestStatus.floating: 'floating',
  RequestStatus.assigned: 'assigned',
  RequestStatus.expired: 'expired',
};

const _$RepeatTypeEnumMap = {
  RepeatType.none: 'none',
  RepeatType.daily: 'daily',
  RepeatType.weekly: 'weekly',
};

/// Helper function to convert Firestore Timestamp or String to DateTime
DateTime _convertToDateTime(dynamic value) {
  if (value is Timestamp) {
    return value.toDateTime(); // Convert Firestore Timestamp to DateTime
  } else if (value is String) {
    return DateTime.parse(value); // Convert stored String to DateTime
  } else {
    throw ArgumentError('Invalid date format'); // Handle unexpected cases
  }
}
