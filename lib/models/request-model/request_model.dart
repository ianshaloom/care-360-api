import 'package:care360/models/shift-model/shift_model.dart';
import 'package:care360/utils/timestamp_helper.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'request_model.g.dart';

/// RequestModel class
/// Represents a request for a caregiver in the system.
@JsonSerializable()
class RequestModel {
  /// Constructor for [RequestModel]
  RequestModel({
    required this.requestId,
    required this.careHomeId,
    required this.status,
    required this.careRequirements,
    required this.shiftStartTime,
    required this.shiftEndTime,
    required this.additionalNotes,
    required this.createdAt,
    this.updatedAt,
    this.assignedCaregiverId,
    this.expiresAt,
    this.untilDate,
    this.repeatType = RepeatType.none,
    this.repeatDays,
    this.selectedDates,
  });

  /// Static function to create an empty [RequestModel]
  RequestModel.empty()
      : requestId = '',
        careHomeId = '',
        status = RequestStatus.open,
        careRequirements = '',
        shiftStartTime = DateTime.now(),
        shiftEndTime = DateTime.now(),
        additionalNotes = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        assignedCaregiverId = '',
        expiresAt = DateTime.now(),
        untilDate = DateTime.now(),
        repeatType = RepeatType.none,
        repeatDays = [],
        selectedDates = [];

  /// Static function to create [RequestModel] from a Firestore snapshot
  factory RequestModel.fromSnapshot(Map<String, dynamic> json) =>
      _$RequestModelFromJson(json);

  /// Convert [RequestModel] to a Firestore-compatible map
  Map<String, dynamic> toJson() => _$RequestModelToJson(this);

  /// Convert [RequestModel] to a Firestore-compatible map
  Map<String, dynamic> toDoc() => _$RequestModelToDoc(this);

  /// CopyWith method for [RequestModel]
  RequestModel copyWith({
    String? requestId,
    String? careHomeId,
    RequestStatus? status,
    String? careRequirements,
    DateTime? shiftStartTime,
    DateTime? shiftEndTime,
    String? additionalNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? assignedCaregiverId,
    DateTime? expiresAt,
    DateTime? untilDate,
    RepeatType? repeatType,
    List<int>? repeatDays,
    List<DateTime>? selectedDates,
  }) {
    return RequestModel(
      requestId: requestId ?? this.requestId,
      careHomeId: careHomeId ?? this.careHomeId,
      status: status ?? this.status,
      careRequirements: careRequirements ?? this.careRequirements,
      shiftStartTime: shiftStartTime ?? this.shiftStartTime,
      shiftEndTime: shiftEndTime ?? this.shiftEndTime,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      assignedCaregiverId: assignedCaregiverId ?? this.assignedCaregiverId,
      expiresAt: expiresAt ?? this.expiresAt,
      untilDate: untilDate ?? this.untilDate,
      repeatType: repeatType ?? this.repeatType,
      repeatDays: repeatDays ?? this.repeatDays,
      selectedDates: selectedDates ?? this.selectedDates,
    );
  }

  /// Convert [RequestModel] to a JSON map -- used when
  /// sending Notification data
  Map<String, String> toNotificationJson() {
    return {
      'requestId': requestId,
      'careHomeId': careHomeId,
      'status': status.name,
      'careRequirements': careRequirements,
      'shiftStartTime': shiftStartTime.toIso8601String(),
      'shiftEndTime': shiftEndTime.toIso8601String(),
      'additionalNotes': additionalNotes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String() ?? '',
      'assignedCaregiverId': assignedCaregiverId ?? '',
      'expiresAt': expiresAt?.toIso8601String() ?? '',
    };
  }

  /// Static function to convert a list of [RequestModel] to a list of maps
  static List<Map<String, dynamic>> modelsToJsons(List<RequestModel> shifts) =>
      shifts.map((shift) => shift.toJson()).toList();

  /// Create a List of [ShiftModel] from a [RequestModel]
  /// If the request is a one-time request, it will return a single shift
  /// If the request is a repeating request, it will return multiple shifts
  /// based on the repeat type and dates

  List<ShiftModel> generateShifts({
    String clientId = '',
  }) {
    // if the client and caregiver ID are empty, return an empty list
    final caregiverId = assignedCaregiverId ?? '';
    if (clientId.isEmpty && caregiverId.isEmpty) {
      return [];
    }

    final shifts = <ShiftModel>[];

    final shift = ShiftModel(
      shiftId: const Uuid().v4(),
      careHomeId: careHomeId,
      caregiverId: caregiverId,
      clientId: clientId,
      startTime: shiftStartTime,
      endTime: shiftEndTime,
      status: ShiftStatus.scheduled,
      notes: [additionalNotes],
      createdAt: DateTime.now(),
    );

    // add the first shift
    shifts.add(shift);

    // if the request is a one-time request, return the single shift
    if ((repeatType == RepeatType.none) && (selectedDates == null)) {
      return shifts;
    }

    // if the request repeat is none but has selected dates
    // create multiple shifts
    if ((repeatType == RepeatType.none) && (selectedDates != null)) {
      for (final date in selectedDates!) {
        final newShift = shift.copyWith(
          startTime: DateTime(
            date.year,
            date.month,
            date.day,
            shiftStartTime.hour,
            shiftStartTime.minute,
          ),
          endTime: DateTime(
            date.year,
            date.month,
            date.day,
            shiftEndTime.hour,
            shiftEndTime.minute,
          ),
        );

        // check if the shift is the same as the first shift
        // if it is, skip it
        if ((newShift.startTime.day == shift.startTime.day) &&
            (newShift.startTime.month == shift.startTime.month) &&
            (newShift.startTime.hour == shift.startTime.hour)) {
          continue;
        }

        shifts.add(newShift);
      }
    }

    // if the request is a daily repeating request, create multiple shifts
    if (repeatType == RepeatType.daily) {
      // the until date is the last day of the repetition
      // usually the shift first day + 6 days
      // which makes it a week
      final until = untilDate ?? shiftStartTime.add(const Duration(days: 6));
      final days = until.difference(shiftStartTime).inDays;

      for (var i = 1; i <= days; i++) {
        final s = shiftStartTime.add(Duration(days: i));
        final e = shiftEndTime.add(Duration(days: i));

        final newShift = shift.copyWith(
          startTime: DateTime(
            s.year,
            s.month,
            s.day,
            shiftStartTime.hour,
            shiftStartTime.minute,
          ),
          endTime: DateTime(
            e.year,
            e.month,
            e.day,
            shiftEndTime.hour,
            shiftEndTime.minute,
          ),
        );

        // check if the shift is the same as the first shift
        // if it is, skip it
        if ((newShift.startTime.day == shift.startTime.day) &&
            (newShift.startTime.month == shift.startTime.month) &&
            (newShift.startTime.hour == shift.startTime.hour)) {
          continue;
        }

        shifts.add(newShift);
      }
    }

    // if the request is a weekly repeating request, create multiple shifts
    if (repeatType == RepeatType.weekly) {
      // get repeat days dates
      final repeatDates = _getRepeatDates(shiftStartTime, repeatDays!);

      for (final date in repeatDates) {
        final newShift = shift.copyWith(
          startTime: _shiftDateTime(shiftStartTime, date),
          endTime: _shiftDateTime(shiftEndTime, date),
        );

        // check if the shift is the same as the first shift
        // if it is, skip it
        if ((newShift.startTime.day == shift.startTime.day) &&
            (newShift.startTime.month == shift.startTime.month) &&
            (newShift.startTime.hour == shift.startTime.hour)) {
          continue;
        }

        shifts.add(newShift);
      }
    }

    return shifts;
  }

  List<DateTime> _getRepeatDates(DateTime startDate, List<int> days) {
    final dates = <DateTime>[];
    final start = startDate;
    final end = untilDate ?? startDate.add(const Duration(days: 6));

    for (var i = 0; i <= end.difference(start).inDays; i++) {
      final date = start.add(Duration(days: i));
      if (days.contains(date.weekday)) {
        dates.add(date);
      }
    }
    return dates;
  }

  /// Unique identifier for the request
  final String requestId;

  /// ID of the care home making the request
  final String careHomeId;

  /// Status of the request (e.g., "open", "assigned", "expired")
  final RequestStatus status;

  /// Type of care required (e.g., medical, personal)
  final String careRequirements;

  /// Additional notes or instructions for the caregiver
  final String additionalNotes;

  /// ID of the caregiver assigned to the request (if any)
  final String? assignedCaregiverId;

  /// --------------- Time Fields --------------- ///

  /// Start time of the requested shift
  final DateTime shiftStartTime;

  /// End time of the requested shift
  final DateTime shiftEndTime;

  /// End date of the requested shift
  final DateTime? untilDate;

  /// Repeat type for the shift
  final RepeatType repeatType;

  /// Repeat days for the shift // Used for weekly repetition (0 = Sunday)
  final List<int>? repeatDays;

  /// Specific dates for shift
  final List<DateTime>? selectedDates;

  /// Timestamp when the request was created
  final DateTime createdAt;

  /// Timestamp when the request was last updated
  final DateTime? updatedAt;

  /// Timestamp when the request expires
  final DateTime? expiresAt;

  /// Override toString method for better logging and debugging
  @override
  String toString() {
    return 'RequestModel{requestId: $requestId, careHomeId: $careHomeId,'
        ' status: $status, careRequirements: $careRequirements,'
        ' shiftStartTime: $shiftStartTime, shiftEndTime: $shiftEndTime,'
        ' additionalNotes: $additionalNotes, createdAt: $createdAt,'
        ' updatedAt: $updatedAt, assignedCaregiverId: $assignedCaregiverId,'
        ' expiresAt: $expiresAt, untilDate: $untilDate, '
        ' repeatType: $repeatType,'
        ' repeatDays: $repeatDays, selectedDates: $selectedDates}';
  }
}

/// Enum for the type of repetition for a shift
enum RepeatType {
  /// No repetition (only on selected dates)
  none,

  /// Repeats every day
  daily,

  /// Repeats on selected day(s) of the week
  weekly
}

/// Extension for RepeatType enum
extension RepeatTypeExtension on RepeatType {
  /// Convert RepeatType to a string
  String get name {
    switch (this) {
      case RepeatType.none:
        return 'None';
      case RepeatType.daily:
        return 'Daily';
      case RepeatType.weekly:
        return 'Weekly';
    }
  }
}

/// Extension for RepeatType enum
extension RepeatTypeStringExtension on String {
  /// Convert string to RepeatType
  RepeatType get repeatType {
    switch (this) {
      case 'None':
        return RepeatType.none;
      case 'Daily':
        return RepeatType.daily;
      case 'Weekly':
        return RepeatType.weekly;
      default:
        return RepeatType.none;
    }
  }
}

/// Request Status enum
enum RequestStatus {
  /// Request is open and available for caregivers
  open,

  /// Request is floating, waiting for a caregiver to accept
  floating,

  /// Request has been assigned to a caregiver
  assigned,

  /// Request has expired
  expired
}

/// Extension for RequestStatus enum
extension RequestStatusExtension on RequestStatus {
  /// Convert RequestStatus to a string
  String get name {
    switch (this) {
      case RequestStatus.open:
        return 'Open';
      case RequestStatus.floating:
        return 'Floating';
      case RequestStatus.assigned:
        return 'Assigned';
      case RequestStatus.expired:
        return 'Expired';
    }
  }
}

/// Extension for RequestStatus enum
extension RequestStatusStringExtension on String {
  /// Convert string to RequestStatus
  RequestStatus get requestStatus {
    switch (this) {
      case 'Open':
        return RequestStatus.open;
      case 'Floating':
        return RequestStatus.floating;
      case 'Assigned':
        return RequestStatus.assigned;
      case 'Expired':
        return RequestStatus.expired;
      default:
        return RequestStatus.open;
    }
  }
}

/// Keep the time aspect of the d

DateTime _shiftDateTime(DateTime shiftTime, DateTime newDate) {
  return DateTime(
    newDate.year,
    newDate.month,
    newDate.day,
    shiftTime.hour,
    shiftTime.minute,
  );
}

/*  /// factory constructor of [RequestModel] from [DocumentSnapshot]
  factory RequestModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;

    return RequestModel(
      requestId: document.id,
      careHomeId: data['careHomeId'] as String,
      status: (data['status'] as String).requestStatus,
      careRequirements: data['careRequirements'] as String,
      shiftStartTime: DateTime.parse(data['shiftStartTime'] as String),
      shiftEndTime: DateTime.parse(data['shiftEndTime'] as String),
      additionalNotes: data['additionalNotes'] as String,
      createdAt: DateTime.parse(data['createdAt'] as String),
      updatedAt: data['updatedAt'] == null
          ? null
          : DateTime.parse(data['updatedAt'] as String),
      assignedCaregiverId: data['assignedCaregiverId'] as String?,
      expiresAt: data['expiresAt'] == null
          ? null
          : DateTime.parse(data['expiresAt'] as String),
      untilDate: data['untilDate'] == null
          ? null
          : DateTime.parse(data['untilDate'] as String),
      repeatType: (data['repeatType'] as String).repeatType,
      repeatDays: (data['repeatDays'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      selectedDates: (data['selectedDates'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList(),
    );
  } */
