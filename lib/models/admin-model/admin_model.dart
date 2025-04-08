import 'package:care360/utils/helpers/timestamp_helper.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_model.g.dart';

/// AdminModel class
/// Represents an admin user in the system.
@JsonSerializable()
class AdminModel {
  /// Constructor for [AdminModel]
  AdminModel({
    required this.uid,
    required this.fullname,
    required this.email,
    required this.phone,
    required this.createdAt,
    this.profileImage,
    this.notificationToken,
    this.role = 'user',
    this.updatedAt,
  });

  /// Static function to create an empty [AdminModel]
  AdminModel.empty()
      : role = '',
        uid = '',
        fullname = '',
        email = '',
        phone = '',
        profileImage = '',
        notificationToken = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Static function to create [AdminModel] from a Firestore snapshot
  factory AdminModel.fromSnapshot(Map<String, dynamic> json) =>
      _$AdminModelFromJson(json);

  /// Convert [AdminModel] to a Firestore-compatible map
  Map<String, dynamic> toJson() => _$AdminModelToJson(this);

  /// Convert [AdminModel] to a Firestore-compatible map
  Map<String, dynamic> toDoc() => _$AdminModelToDoc(this);

  /// Role of the admin
  final String role;

  /// Firebase Authentication UID linked to the admin
  final String uid;

  /// Full name of the admin
  final String fullname;

  ///  Email Address of the admin
  final String email;

  /// Contact phone number of the admin
  final String phone;

  /// Profile Image URL of the admin
  final String? profileImage;

  /// Notification Token of the admin
  final String? notificationToken;

  /// Timestamp when the admin was created
  final DateTime createdAt;

  /// Timestamp when the admin was last updated
  final DateTime? updatedAt;

  /// Override toString method for better logging and debugging
  @override
  String toString() {
    return '\nAdminModel { role: $role, uid: $uid, fullname: $fullname, '
        'email: $email, phone: $phone, createdAt: $createdAt, '
        'updatedAt: $updatedAt, profileImage: $profileImage,'
        ' notificationToken: $notificationToken }\n';
  }
}
