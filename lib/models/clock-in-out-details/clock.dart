import 'package:care360/utils/helpers/timestamp_helper.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clock.g.dart';

/// CaregiverModel class
/// Represents a caregiver in the system.
///
@JsonSerializable()

///
class Clock {
  ///
  Clock({
    required this.time,
    required this.long,
    required this.lat,
  });

  /// Static function to create [Clock] from a Firestore snapshot
  factory Clock.fromSnapshot(Map<String, dynamic> json) =>
      _$ClockFromJson(json);

  ///
  // empty constructor
  Clock.empty()
      : time = DateTime.now(),
        long = 0.0,
        lat = 0.0;

  ///
  final DateTime time;

  ///
  final double long;

  ///
  final double lat;

  /// Convert [Clock] to a Firestore-compatible map
  Map<String, dynamic> toJson() => _$ClockToJson(this);

  /// Convert [Clock] to a Firestore-compatible map
  Map<String, dynamic> toDoc() => _$ClockToDoc(this);
}
