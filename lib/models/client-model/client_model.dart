import 'package:json_annotation/json_annotation.dart';

part 'client_model.g.dart';

/// ClientModel class
/// Represents a client in the system.
@JsonSerializable()
class ClientModel {
  /// Constructor for [ClientModel]
  ClientModel({
    required this.clientId,
    required this.name,
    required this.age,
    required this.location,
    required this.coordinates,
    required this.medicalHistory,
    required this.carePlan,
    required this.assignedCaregivers,
    required this.imageUrl,
    required this.createdAt,
    this.updatedAt,
  });

  /// Static function to create an empty [ClientModel]
  ClientModel.empty()
      : clientId = '',
        name = '',
        age = 0,
        location = '',
        coordinates = null,
        medicalHistory = '',
        carePlan = '',
        assignedCaregivers = [],
        imageUrl = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Static function to create [ClientModel] from a Firestore snapshot
  factory ClientModel.fromSnapshot(Map<String, dynamic> json) =>
      _$ClientModelFromJson(json);

  /// Convert [ClientModel] to a Firestore-compatible map
  Map<String, dynamic> toSnapshot() => _$ClientModelToJson(this);

  /// Unique identifier for the client
  final String clientId;

  /// Full name of the client
  final String name;

  /// Age of the client
  final int age;

  /// Location of the client
  final String location;

  /// GPS coordinates of the client location (latitude, longitude)
  final Map<String, double>? coordinates;

  /// Medical history of the client
  final String medicalHistory;

  /// Care plan for the client
  final String carePlan;

  /// List of caregiver IDs assigned to the client
  final List<String> assignedCaregivers;

  /// Image URL of the client
  final String? imageUrl;

  /// Timestamp when the client was created
  final DateTime createdAt;

  /// Timestamp when the client was last updated
  final DateTime? updatedAt;

  /// Override toString method for better logging and debugging
  @override
  String toString() {
    return 'ClientModel{clientId: $clientId, name: $name, age: $age,'
        ' location: $location, coordinates: $coordinates, medicalHistory: $medicalHistory,'
        ' carePlan: $carePlan, assignedCaregivers: $assignedCaregivers, imageUrl: $imageUrl,'
        ' createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
