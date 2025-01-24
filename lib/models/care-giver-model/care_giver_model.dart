import 'package:json_annotation/json_annotation.dart';

part 'care_giver_model.g.dart';

/// CaregiverModel class
/// Represents a caregiver in the system.
@JsonSerializable()
class CaregiverModel {
  /// Constructor for [CaregiverModel]
  CaregiverModel({
    required this.caregiverId,
    required this.uid,
    required this.name,
    required this.phone,
    required this.qualifications,
    // required this.preferredCareTypes,
    required this.availability,
    required this.assignedShifts,
    required this.registeredCode,
    required this.createdAt,
    this.updatedAt,
  });

  /// Static function to create an empty [CaregiverModel]
  CaregiverModel.empty()
      : caregiverId = '',
        uid = '',
        name = '',
        phone = '',
        qualifications = [],
        // preferredCareTypes = [],
        availability = [],
        assignedShifts = [],
        registeredCode = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Static function to create [CaregiverModel] from a Firestore snapshot
  factory CaregiverModel.fromSnapshot(Map<String, dynamic> json) =>
      _$CaregiverModelFromJson(json);

  /// Convert [CaregiverModel] to a Firestore-compatible map
  Map<String, dynamic> toSnapshot() => _$CaregiverModelToJson(this);

  /// Unique identifier for the caregiver
  final String caregiverId;

  /// Firebase Authentication UID linked to the caregiver
  final String uid;

  /// Full name of the caregiver
  final String name;

  /// Contact phone number of the caregiver
  final String phone;

  /// List of qualifications the caregiver possesses
  final List<String> qualifications;

  /// List of preferred care types the caregiver can provide
  // final List<String> preferredCareTypes;

  /// List of days/times the caregiver is available
  final List<String> availability;

  /// List of shift IDs assigned to the caregiver
  final List<String> assignedShifts;

  /// Unique registration code for the caregiver
  final String registeredCode;

  /// Timestamp when the caregiver was created
  final DateTime createdAt;

  /// Timestamp when the caregiver was last updated
  final DateTime? updatedAt;

  /// Override toString method for better logging and debugging
  @override
  String toString() {
    return 'CaregiverModel{caregiverId: $caregiverId, uid: $uid, name: $name, phone: $phone,'
        ' qualifications: $qualifications, availability: $availability,'
        ' assignedShifts: $assignedShifts, registeredCode: $registeredCode,'
        ' createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
