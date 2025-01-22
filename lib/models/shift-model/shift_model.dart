import 'package:json_annotation/json_annotation.dart';

part 'shift_model.g.dart';

/// ShiftModel class
/// Represents a shift assigned to a caregiver in the system.
@JsonSerializable()
class ShiftModel {
  /// Constructor for [ShiftModel]
  ShiftModel({
    required this.shiftId,
    required this.caregiverId,
    required this.clientId,
    required this.careHomeId,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.notes,
    required this.createdAt,
    this.updatedAt,
    this.clockInTime,
    this.clockOutTime,
    this.clockInLocation,
    this.clockOutLocation,
  });

  /// Static function to create an empty [ShiftModel]
  ShiftModel.empty()
      : shiftId = '',
        caregiverId = '',
        clientId = '',
        careHomeId = '',
        startTime = DateTime.now(),
        endTime = DateTime.now(),
        status = '',
        notes = [],
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        clockInTime = DateTime.now(),
        clockOutTime = DateTime.now(),
        clockInLocation = null,
        clockOutLocation = null;

  /// Static function to create [ShiftModel] from a Firestore snapshot
  factory ShiftModel.fromSnapshot(Map<String, dynamic> json) =>
      _$ShiftModelFromJson(json);

  /// Convert [ShiftModel] to a Firestore-compatible map
  Map<String, dynamic> toSnapshot() => _$ShiftModelToJson(this);

  /// Unique identifier for the shift
  final String shiftId;

  /// ID of the caregiver assigned to the shift
  final String caregiverId;

  /// ID of the client receiving care during the shift
  final String clientId;

  /// ID of the care home managing the shift
  final String careHomeId;

  /// Start time of the shift
  final DateTime startTime;

  /// End time of the shift
  final DateTime endTime;

  /// Status of the shift (e.g., "scheduled", "in-progress", "completed")
  final String status;

  /// List of notes or instructions for the shift
  final List<String> notes;

  /// Timestamp when the shift was created
  final DateTime createdAt;

  /// Timestamp when the shift was last updated
  final DateTime? updatedAt;

  /// Timestamp when the caregiver clocked in
  final DateTime? clockInTime;

  /// Timestamp when the caregiver clocked out
  final DateTime? clockOutTime;

  /// GPS coordinates of the clock-in location (latitude, longitude)
  final Map<String, double>? clockInLocation;

  /// GPS coordinates of the clock-out location (latitude, longitude)
  final Map<String, double>? clockOutLocation;

  /// Override toString method for better logging and debugging
  @override
  String toString() {
    return 'ShiftModel{shiftId: $shiftId, caregiverId: $caregiverId,'
        ' clientId: $clientId, careHomeId: $careHomeId, startTime: $startTime,'
        ' endTime: $endTime, status: $status, notes: $notes, createdAt: $createdAt,'
        ' updatedAt: $updatedAt, clockInTime: $clockInTime, clockOutTime: $clockOutTime,'
        ' clockInLocation: $clockInLocation, clockOutLocation: $clockOutLocation}';
  }
}
