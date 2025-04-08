import 'package:care360/utils/helpers/timestamp_helper.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'care_home_model.g.dart';

/// CareHomeModel class
/// Represents a care home in the system.
@JsonSerializable()
class CareHomeModel {
  /// Constructor for [CareHomeModel]
  CareHomeModel({
    required this.careHomeId,
    required this.uid,
    required this.fullname,
    required this.email,
    required this.address,
    required this.phone,
    required this.requests,
    required this.createdAt,
    this.profileImage,
    this.notificationToken,
    this.updatedAt,
  });

  /// Static function to create an empty [CareHomeModel]
  CareHomeModel.empty()
      : careHomeId = '',
        uid = '',
        fullname = '',
        email = '',
        address = '',
        phone = '',
        profileImage = '',
        notificationToken = '',
        requests = [],
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Static function to create [CareHomeModel] from a Firestore snapshot
  factory CareHomeModel.fromSnapshot(Map<String, dynamic> json) =>
      _$CareHomeModelFromJson(json);

  /// Convert [CareHomeModel] to a Firestore-compatible map
  Map<String, dynamic> toJson() => _$CareHomeModelToJson(this);

  /// Convert [CareHomeModel] to a Firestore-compatible map
  Map<String, dynamic> toDoc() => _$CareHomeModelToDoc(this);

  /// Unique identifier for the care home
  final String careHomeId;

  /// Firebase Authentication UID linked to the care home
  final String uid;

  /// Name of the care home
  final String fullname;

  /// Email Address of the care home
  final String email;

  /// Address of the care home
  final String address;

  /// Contact phone number of the care home
  final String phone;

  /// Profile Image URL of the care home
  final String? profileImage;

  /// Notification Token of the care home
  final String? notificationToken;

  /// List of request IDs associated with the care home
  final List<String> requests;

  /// Timestamp when the care home was created
  final DateTime createdAt;

  /// Timestamp when the care home was last updated
  final DateTime? updatedAt;

  /// Override toString method for better logging and debugging
  @override
  String toString() {
    return '\nCareHomeModel { careHomeId: $careHomeId, uid: $uid,'
    ' name: $fullname email: $email, address: $address, phone: $phone,'
    ' requests: $requests, createdAt: $createdAt, updatedAt: $updatedAt, '
        'profileImage: $profileImage, notificationToken: $notificationToken'
        ' }\n';
  }
}
