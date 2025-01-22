import 'package:json_annotation/json_annotation.dart';

part 'admin_model.g.dart';

/// AdminModel class
/// Represents an admin user in the system.
@JsonSerializable()
class AdminModel {
  /// Constructor for [AdminModel]
  AdminModel({
    required this.adminId,
    required this.uid,
    required this.name,
    required this.phone,
    required this.createdAt,
    this.updatedAt,
  });

  /// Static function to create an empty [AdminModel]
  AdminModel.empty()
      : adminId = '',
        uid = '',
        name = '',
        phone = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Static function to create [AdminModel] from a Firestore snapshot
  factory AdminModel.fromSnapshot(Map<String, dynamic> json) =>
      _$AdminModelFromJson(json);

  /// Convert [AdminModel] to a Firestore-compatible map
  Map<String, dynamic> toSnapshot() => _$AdminModelToJson(this);

  /// Unique identifier for the admin
  final String adminId;

  /// Firebase Authentication UID linked to the admin
  final String uid;

  /// Full name of the admin
  final String name;

  /// Contact phone number of the admin
  final String phone;

  /// Timestamp when the admin was created
  final DateTime createdAt;

  /// Timestamp when the admin was last updated
  final DateTime? updatedAt;

  /// Override toString method for better logging and debugging
  @override
  String toString() {
    return 'AdminModel{adminId: $adminId, uid: $uid, name: $name, phone: $phone,'
        ' createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
