import 'package:care360/models/request-model/request_model.dart';
import 'package:care360/utils/timestamp_helper.dart';
import 'package:dart_firebase_admin/firestore.dart';
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
    required this.floatStatus,
    required this.notes,
    required this.createdAt,
    this.updatedAt,
    this.clockInTime,
    this.clockOutTime,
    this.clockInLocation,
    this.clockOutLocation,
  });

  /// Factory constructor of [ShiftModel] from [RequestModel]
  factory ShiftModel.fromRequest(RequestModel request) {
    return ShiftModel(
      shiftId: request.requestId,
      caregiverId: request.assignedCaregiverId!,
      clientId: '',
      careHomeId: request.careHomeId,
      startTime: request.shiftStartTime,
      endTime: request.shiftEndTime,
      status: ShiftStatus.scheduled,
      floatStatus: FloatStatus.notFloated,
      notes: [request.additionalNotes],
      createdAt: request.createdAt,
      updatedAt: request.updatedAt ?? request.createdAt,
    );
  }

  /// Static function to create an empty [ShiftModel]
  ShiftModel.empty()
      : shiftId = '',
        caregiverId = '',
        clientId = '',
        careHomeId = '',
        startTime = DateTime.now(),
        endTime = DateTime.now(),
        status = ShiftStatus.scheduled,
        floatStatus = FloatStatus.notFloated,
        notes = [],
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        clockInTime = DateTime.now(),
        clockOutTime = DateTime.now(),
        clockInLocation = null,
        clockOutLocation = null;

  /// Static function to create [ShiftModel] from a Firestore snapshot
  factory ShiftModel.fromSnapshot(Map<String, Object?> json) =>
      _$ShiftModelFromJson(json);

  /// Convert [ShiftModel] to a JSON map -- used by HTTP requests
  Map<String, dynamic> toJson() => _$ShiftModelToJson(this);

  /// Convert [ShiftModel] to a Firestore-compatible map
  Map<String, dynamic> toDoc() => _$ShiftModelToDoc(this);

  /// Convert [ShiftModel] to a JSON map -- used when sending Notification data
  Map<String, String> toNotificationJson() {
    return {
      'shiftId': shiftId,
      'caregiverId': caregiverId,
      'clientId': clientId,
      'careHomeId': careHomeId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status.value,
      'floatStatus': floatStatus.value,
      'notes': notes.join('---'),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String() ?? '',
      'clockInTime': clockInTime?.toIso8601String() ?? '',
      'clockOutTime': clockOutTime?.toIso8601String() ?? '',
      'clockInLocation': clockInLocation?.toString() ?? '',
      'clockOutLocation': clockOutLocation?.toString() ?? '',
    };
  }

  /// Static function to convert a list of ShiftModel to a list of maps
  static List<Map<String, dynamic>> modelsToJsons(List<ShiftModel> shifts) =>
      shifts.map((shift) => shift.toJson()).toList();

  /// A CopyWith method to update the ShiftModel
  ShiftModel copyWith({
    String? shiftId,
    String? caregiverId,
    String? clientId,
    String? careHomeId,
    DateTime? startTime,
    DateTime? endTime,
    ShiftStatus? status,
    FloatStatus? floatStatus,
    List<String>? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? clockInTime,
    DateTime? clockOutTime,
    Map<String, double>? clockInLocation,
    Map<String, double>? clockOutLocation,
  }) {
    return ShiftModel(
      shiftId: shiftId ?? this.shiftId,
      caregiverId: caregiverId ?? this.caregiverId,
      clientId: clientId ?? this.clientId,
      careHomeId: careHomeId ?? this.careHomeId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      floatStatus: floatStatus ?? this.floatStatus,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      clockInTime: clockInTime ?? this.clockInTime,
      clockOutTime: clockOutTime ?? this.clockOutTime,
      clockInLocation: clockInLocation ?? this.clockInLocation,
      clockOutLocation: clockOutLocation ?? this.clockOutLocation,
    );
  }

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
  final ShiftStatus status;

  /// Status of the float request shift
  final FloatStatus floatStatus;

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
    return '\nShiftModel { shiftId: $shiftId, caregiverId: $caregiverId,'
        ' clientId: $clientId, careHomeId: $careHomeId,'
        ' startTime: $startTime,'
        ' endTime: $endTime, status: $status, notes: $notes,'
        ' createdAt: $createdAt, floatStatus: $floatStatus,'
        ' updatedAt: $updatedAt, clockInTime: $clockInTime,'
        ' clockOutTime: $clockOutTime,'
        ' clockInLocation: $clockInLocation, '
        'clockOutLocation: $clockOutLocation } \n';
  }
}

/// Enum for the status of a shift
enum ShiftStatus {
  /// Shift is scheduled but not yet started
  scheduled,

  /// Shift is in progress (caregiver is clocked in)
  inProgress,

  /// Shift is completed (caregiver has clocked out)
  completed,

  /// Shift is missed (caregiver did not clock in)
  missed,

  /// Shift is cancelled (carehome or admin cancelled the shift)
  cancelled,
}

/// Extension method to convert a [ShiftStatus] to a string
extension ShiftStatusExtension on ShiftStatus {
  /// Convert a [ShiftStatus] to a string
  String get value {
    switch (this) {
      case ShiftStatus.scheduled:
        return 'scheduled';
      case ShiftStatus.inProgress:
        return 'in-progress';
      case ShiftStatus.completed:
        return 'completed';
      case ShiftStatus.missed:
        return 'missed';
      case ShiftStatus.cancelled:
        return 'cancelled';
    }
  }
}

/// Extension method to convert a string to a [ShiftStatus]
extension StringToShiftStatus on String {
  /// Convert a string to a [ShiftStatus]
  ShiftStatus get toShiftStatus {
    switch (this) {
      case 'scheduled':
        return ShiftStatus.scheduled;
      case 'in-progress':
        return ShiftStatus.inProgress;
      case 'completed':
        return ShiftStatus.completed;
      case 'missed':
        return ShiftStatus.missed;
      case 'cancelled':
        return ShiftStatus.cancelled;
      default:
        return ShiftStatus.scheduled;
    }
  }
}

/// Enum for the status of a float request shift
enum FloatStatus {
  /// Shift is floated successfully
  floating,

  /// Shift is not floated
  notFloated,

  /// Shift floated and picked by a caregiver
  picked,
}

/// Extension method to convert a [FloatStatus] to a string
extension FloatStatusExtension on FloatStatus {
  /// Convert a [FloatStatus] to a string
  String get value {
    switch (this) {
      case FloatStatus.floating:
        return 'floating';
      case FloatStatus.notFloated:
        return 'not-floated';
      case FloatStatus.picked:
        return 'picked';
    }
  }
}

/// Extension method to convert a string to a [FloatStatus]
extension StringToFloatStatus on String {
  /// Convert a string to a [FloatStatus]
  FloatStatus get toFloatStatus {
    switch (this) {
      case 'floating':
        return FloatStatus.floating;
      case 'not-floated':
        return FloatStatus.notFloated;
      case 'picked':
        return FloatStatus.picked;
      default:
        return FloatStatus.notFloated;
    }
  }
}

/*
*   /// factory constructor of [ShiftModel] from [DocumentSnapshot]
  factory ShiftModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;

    return ShiftModel(
      shiftId: document.id,
      caregiverId: data['caregiverId'] as String,
      clientId: data['clientId'] as String,
      careHomeId: data['careHomeId'] as String,
      status: data['status'] as String,
      notes: (data['notes'] as List<dynamic>).map((e) => e as String).toList(),
      clockInLocation: (data['clockInLocation'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      clockOutLocation:
          (data['clockOutLocation'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      startTime: (data['startTime'] as Timestamp).toDateTime(),
      endTime: (data['endTime'] as Timestamp).toDateTime(),
      createdAt: (data['createdAt'] as Timestamp).toDateTime(),
      updatedAt: data['updatedAt'] == null
          ? null
          : (data['updatedAt'] as Timestamp).toDateTime(),
      clockInTime: data['clockInTime'] == null
          ? null
          : (data['clockInTime'] as Timestamp).toDateTime(),
      clockOutTime: data['clockOutTime'] == null
          ? null
          : (data['clockOutTime'] as Timestamp).toDateTime(),
    );
  }
 */
