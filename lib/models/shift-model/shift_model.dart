import 'package:care360/models/client-details/client_details.dart';
import 'package:care360/models/clock-in-out-details/clock.dart';
import 'package:care360/models/request-model/request_model.dart';
import 'package:care360/utils/helpers/timestamp_helper.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'shift_model.g.dart';

/// ShiftModel class
/// Represents a shift assigned to a caregiver in the system.
@JsonSerializable()
class ShiftModel {
  /// Constructor for [ShiftModel]
  ShiftModel({
    required this.shiftId,
    required this.requestId,
    required this.caregiverId,
    required this.clientId,
    required this.clientType,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.floatStatus,
    required this.notes,
    required this.createdAt,
    required this.clientDetails,
    this.updatedAt,
    this.clockOut,
    this.clockIn,
  });

  /// Factory constructor of [ShiftModel] from [RequestModel]
  factory ShiftModel.fromRequest(RequestModel request) {
    return ShiftModel(
      shiftId: const Uuid().v4(),
      requestId: request.requestId,
      caregiverId: request.assignedCaregiverId!,
      clientId: '',
      clientType: request.clientType.name,
      startTime: request.shiftStartTime,
      endTime: request.shiftEndTime,
      status: ShiftStatus.scheduled,
      floatStatus: FloatStatus.notFloated,
      notes: {
        'careRequirements': request.careRequirements ?? '',
        'additionalNotes': request.additionalNotes ?? '',
      },
      createdAt: request.createdAt,
      updatedAt: request.updatedAt ?? request.createdAt,
      clientDetails: request.clientDetails,
    );
  }

  /// Static function to create an empty [ShiftModel]
  ShiftModel.empty()
      : shiftId = '',
        requestId = '',
        caregiverId = '',
        clientId = '',
        clientType = '',
        startTime = DateTime.now(),
        endTime = DateTime.now(),
        status = ShiftStatus.scheduled,
        floatStatus = FloatStatus.notFloated,
        notes = {},
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        clientDetails = ClientDetails.empty(),
        clockIn = Clock.empty(),
        clockOut = Clock.empty();

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
      'requestId': requestId,
      'caregiverId': caregiverId,
      'clientId': clientId,
      'clientType': clientType,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status.value,
      'floatStatus': floatStatus.value,
      'notes': notes.toString(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String() ?? '',
      'clockIn': clockIn!.toJson().toString(),
      'clockOut': clockOut!.toJson().toString(),
      'careHome': clientDetails.toJson().toString(),
    };
  }

  /// Static function to convert a list of ShiftModel to a list of maps
  static List<Map<String, dynamic>> modelsToJsons(List<ShiftModel> shifts) =>
      shifts.map((shift) => shift.toJson()).toList();

  /// A CopyWith method to update the ShiftModel
  ShiftModel copyWith({
    String? shiftId,
    String? requestId,
    String? caregiverId,
    String? clientId,
    String? clientType,
    DateTime? startTime,
    DateTime? endTime,
    ShiftStatus? status,
    FloatStatus? floatStatus,
    Map<String, String>? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    Clock? clockIn,
    Clock? clockOut,
    ClientDetails? clientDetails,
  }) {
    return ShiftModel(
      shiftId: shiftId ?? this.shiftId,
      requestId: requestId ?? this.requestId,
      caregiverId: caregiverId ?? this.caregiverId,
      clientId: clientId ?? this.clientId,
      clientType: clientType ?? this.clientType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      floatStatus: floatStatus ?? this.floatStatus,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
      clientDetails: clientDetails ?? this.clientDetails,
    );
  }

  /// Unique identifier for the shift
  final String shiftId;

  /// The request ID of the shift
  final String requestId;

  /// ID of the caregiver assigned to the shift
  final String caregiverId;

  /// ID of the client receiving care during the shift
  final String clientId;

  /// client type
  final String clientType;


  /// Status of the shift (e.g., "scheduled", "in-progress", "completed")
  final ShiftStatus status;

  /// Status of the float request shift
  final FloatStatus floatStatus;

    /// Start time of the shift
  final DateTime startTime;

  /// End time of the shift
  final DateTime endTime;

  /// Timestamp when the shift was created
  final DateTime createdAt;

  /// Timestamp when the shift was last updated
  final DateTime? updatedAt;

    /// Timestamp when the caregiver clocked in
  final Clock? clockIn;

  /// Timestamp when the caregiver clocked out
  final Clock? clockOut;

  /// CH_Details
  final ClientDetails clientDetails;

  /// List of notes or instructions for the shift
  final Map<String, String> notes;

  /// Override toString method for better logging and debugging
  @override
  String toString() {
    return '\nShiftModel { shiftId: $shiftId, caregiverId: $caregiverId,'
        ' clientId: $clientId, ,'
        ' startTime: $startTime, requestId: $requestId,'
        ' endTime: $endTime, status: $status, notes: $notes,'
        ' createdAt: $createdAt, floatStatus: $floatStatus,'
        ' updatedAt: $updatedAt, } \n';
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
