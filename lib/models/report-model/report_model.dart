import 'package:json_annotation/json_annotation.dart';

part 'report_model.g.dart';

/// ReportModel class
/// Represents a report generated in the system.
@JsonSerializable()
class ReportModel {
  /// Constructor for [ReportModel]
  ReportModel({
    required this.reportId,
    required this.careHomeId,
    required this.generatedBy,
    required this.content,
    required this.createdAt,
  });

  /// Static function to create an empty [ReportModel]
  ReportModel.empty()
      : reportId = '',
        careHomeId = '',
        generatedBy = '',
        content = '',
        createdAt = DateTime.now();

  /// Static function to create [ReportModel] from a Firestore snapshot
  factory ReportModel.fromSnapshot(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);

  /// Convert [ReportModel] to a Firestore-compatible map
  Map<String, dynamic> toSnapshot() => _$ReportModelToJson(this);

  /// Unique identifier for the report
  final String reportId;

  /// ID of the care home associated with the report
  final String careHomeId;

  /// Firebase Authentication UID of the admin who generated the report
  final String generatedBy;

  /// Content of the report (e.g., performance metrics, operational data)
  final String content;

  /// Timestamp when the report was created
  final DateTime createdAt;

  /// Override toString method for better logging and debugging
  @override
  String toString() {
    return 'ReportModel{reportId: $reportId, careHomeId: $careHomeId,'
        ' generatedBy: $generatedBy, content: $content, createdAt: $createdAt}';
  }
}
