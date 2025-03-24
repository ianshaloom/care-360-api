// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Clock _$ClockFromJson(Map<String, dynamic> json) => Clock(
      time: DateTime.parse(json['time'] as String),
      long: (json['long'] as num).toDouble(),
      lat: (json['lat'] as num).toDouble(),
    );

Map<String, dynamic> _$ClockToJson(Clock instance) => <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'long': instance.long,
      'lat': instance.lat,
    };

Map<String, dynamic> _$ClockToDoc(Clock instance) => <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'long': instance.long,
      'lat': instance.lat,
    };
