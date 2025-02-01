import 'package:care360/utils/timestamp_helper.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'care_giver_model.g.dart';

/// CaregiverModel class
/// Represents a caregiver in the system.
@JsonSerializable()
class CareGiverModel {
  /// Constructor for [CareGiverModel]
  CareGiverModel(
    this.address, {
    required this.uid,
    required this.fullname,
    required this.email,
    required this.createdAt,
    this.profileImage,
    this.notificationToken,
    this.caregiverId = '',
    this.phone = '',
    this.qualifications = const [],
    this.preferredCareTypes = const [],
    this.availability = const [],
    this.assignedShifts = const [],
    this.registeredCode = '',
    this.updatedAt,
    this.isAvailable = true,
  });

  /// Static function to create an empty [CareGiverModel]
  CareGiverModel.empty()
      : caregiverId = '',
        uid = '',
        fullname = '',
        email = '',
        phone = '',
        address = '',
        profileImage = '',
        notificationToken = '',
        qualifications = [],
        preferredCareTypes = [],
        availability = [],
        assignedShifts = [],
        registeredCode = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        isAvailable = false;

  /// Static function to create [CareGiverModel] from a Firestore snapshot
  factory CareGiverModel.fromSnapshot(Map<String, dynamic> json) =>
      _$CareGiverModelFromJson(json);

  /// Convert [CareGiverModel] to a Firestore-compatible map
  Map<String, dynamic> toJson() => _$CareGiverModelToJson(this);

  /// Convert [CareGiverModel] to a Firestore-compatible map
  Map<String, dynamic> toDoc() => _$CareGiverModelToDoc(this);

  /// Unique identifier for the caregiver
  final String caregiverId;

  /// Firebase Authentication UID linked to the caregiver
  final String uid;

  /// Full name of the caregiver
  final String fullname;

  ///  Email Address of the admin
  final String email;

  /// Contact phone number of the caregiver
  final String phone;

  /// Address of the caregiver
  final String address;

  /// Profile Image URL of the caregiver
  final String? profileImage;

  /// Notification Token of the caregiver
  final String? notificationToken;

  /// List of qualifications the caregiver possesses
  final List<String> qualifications;

  /// List of preferred care types the caregiver can provide
  final List<String> preferredCareTypes;

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

  /// Is the caregiver available for the shift
  final bool isAvailable;

  /// List of CaregiverModel objects to a list of Firestore-compatible maps
  static List<Map<String, dynamic>> listToSnapshot(List<CareGiverModel> list) {
    return list.map((e) => e.toJson()).toList();
  }

  /// Override toString method for better logging and debugging
  @override
  String toString() {
    return '\nCaregiverModel { caregiverId: $caregiverId, uid: $uid, '
        'name: $fullname, email: $email, phone: $phone, address: $address,'
        ' qualifications: $qualifications, availability: $availability,'
        ' assignedShifts: $assignedShifts, registeredCode: $registeredCode,'
        ' createdAt: $createdAt, notificationToken: $notificationToken,'
        ' updatedAt: $updatedAt, profileImage: $profileImage,'
        ' isAvailable: $isAvailable }\n';
  }
}
