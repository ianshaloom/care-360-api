import 'package:json_annotation/json_annotation.dart';

part 'care_home.g.dart';

/// CaregiverModel class
/// Represents a caregigfver in the system.
@JsonSerializable()
class CareHome {
  ///
  final String fullName;

  ///
  final String address;

  ///
  CareHome({
    required this.fullName,
    required this.address,
  });

  ///
  // empty constructor
  CareHome.empty()
      : fullName = '',
        address = '';

  /// Static function to create [CareHome] from a Firestore snapshot
  factory CareHome.fromSnapshot(Map<String, dynamic> json) =>
      _$CareHomeFromJson(json);

  /// Convert [CareHome] to a Firestore-compatible map
  Map<String, dynamic> toJson() => _$CareHomeToJson(this);
}
