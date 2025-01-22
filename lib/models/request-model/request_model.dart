import 'package:json_annotation/json_annotation.dart';

part 'request_model.g.dart';

/// RequestModel class
/// Represents a request for a caregiver in the system.
@JsonSerializable()
class RequestModel {
  /// Constructor for [RequestModel]
  RequestModel({
    required this.requestId,
    required this.careHomeId,
    required this.clientId,
    required this.status,
    required this.careRequirements,
    required this.shiftStartTime,
    required this.shiftEndTime,
    required this.additionalNotes,
    required this.createdAt,
    this.updatedAt,
    this.assignedCaregiverId,
    this.expiresAt,
  });

  /// Static function to create an empty [RequestModel]
  RequestModel.empty()
      : requestId = '',
        careHomeId = '',
        clientId = '',
        status = '',
        careRequirements = '',
        shiftStartTime = DateTime.now(),
        shiftEndTime = DateTime.now(),
        additionalNotes = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        assignedCaregiverId = '',
        expiresAt = DateTime.now();

  /// Static function to create [RequestModel] from a Firestore snapshot
  factory RequestModel.fromSnapshot(Map<String, dynamic> json) =>
      _$RequestModelFromJson(json);

  /// Convert [RequestModel] to a Firestore-compatible map
  Map<String, dynamic> toSnapshot() => _$RequestModelToJson(this);

  /// Unique identifier for the request
  final String requestId;

  /// ID of the care home making the request
  final String careHomeId;

  /// ID of the client needing care
  final String clientId;

  /// Status of the request (e.g., "open", "assigned", "expired")
  final String status;

  /// Type of care required (e.g., medical, personal)
  final String careRequirements;

  /// Start time of the requested shift
  final DateTime shiftStartTime;

  /// End time of the requested shift
  final DateTime shiftEndTime;

  /// Additional notes or instructions for the caregiver
  final String additionalNotes;

  /// Timestamp when the request was created
  final DateTime createdAt;

  /// Timestamp when the request was last updated
  final DateTime? updatedAt;

  /// ID of the caregiver assigned to the request (if any)
  final String? assignedCaregiverId;

  /// Timestamp when the request expires
  final DateTime? expiresAt;

  /// Override toString method for better logging and debugging
  @override
  String toString() {
    return 'RequestModel{requestId: $requestId, careHomeId: $careHomeId,'
        ' clientId: $clientId, status: $status, careRequirements: $careRequirements,'
        ' shiftStartTime: $shiftStartTime, shiftEndTime: $shiftEndTime,'
        ' additionalNotes: $additionalNotes, createdAt: $createdAt,'
        ' updatedAt: $updatedAt, assignedCaregiverId: $assignedCaregiverId,'
        ' expiresAt: $expiresAt}';
  }
}
