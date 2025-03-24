// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportModel _$ReportModelFromJson(Map<String, dynamic> json) => ReportModel(
      reportId: json['reportId'] as String,
      careHomeId: json['careHomeId'] as String,
      generatedBy: json['generatedBy'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ReportModelToJson(ReportModel instance) =>
    <String, dynamic>{
      'reportId': instance.reportId,
      'careHomeId': instance.careHomeId,
      'generatedBy': instance.generatedBy,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
    };
