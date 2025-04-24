import 'package:dart_firebase_admin/firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'client_details.g.dart';

/// CaregiverModel class
/// Represents a caregigfver in the system.
@JsonSerializable()
class ClientDetails {
  ///
  ClientDetails({
    required this.fullName,
    required this.address,
    required this.geoPoint,
  });

  ///
  // empty constructor
  ClientDetails.empty()
      : fullName = '',
        address = '',
        geoPoint = GeoPoint(latitude: 0, longitude: 0);

  /// Static function to create [ClientDetails] from a Firestore snapshot
  factory ClientDetails.fromSnapshot(Map<String, dynamic> json) =>
      _$ClientDetailsFromJson(json);

  ///
  final String fullName;

  ///
  final String address;

  ///
  final GeoPoint geoPoint;

  /// Convert [ClientDetails] to a Firestore-compatible map
  Map<String, dynamic> toJson() => _$ClientDetailsToJson(this);
}
