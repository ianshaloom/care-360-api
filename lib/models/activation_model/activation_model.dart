import 'package:json_annotation/json_annotation.dart';

part 'activation_model.g.dart';

/// ActivationModel class
@JsonSerializable()
class ActivationModel {
  /// Constructor for [ActivationModel]
  ActivationModel({
    required this.id,
    required this.code,
    required this.isUsed,
    required this.createdAt,
    this.updatedAt,
    this.usedAt,
    this.expiresAt,
  });

  /// Static function to create empty [ActivationModel]
  ActivationModel.empty()
      : id = '',
        code = '',
        isUsed = false,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        usedAt = DateTime.now(),
        expiresAt = DateTime.now();

  /// Static function to create [ActivationModel] from a map
  factory ActivationModel.fromSnapshot(Map<String, dynamic> json) =>
      _$ActivationModelFromJson(json);

  /// Convert [ActivationModel] to a map
  Map<String, dynamic> toSnapshot() => _$ActivationModelToJson(this);

  /// email as ID
  final String id;

  /// the activation code
  final String code;

  /// has the code been used
  final bool isUsed;

  /// time of creation
  final DateTime createdAt;

  ///  time of last update
  final DateTime? updatedAt;

  ///  time of last use
  final DateTime? usedAt;

  /// time of expiration
  final DateTime? expiresAt;

  /// override toString method
  @override
  String toString() {
    return 'ActivationModel{id: $id, code: $code, isUsed: $isUsed,'
        ' createdAt: $createdAt, updatedAt: $updatedAt,'
        ' usedAt: $usedAt, expiredAt: $expiresAt}';
  }
}

/// Generated activation code of 6 Letters
String generateActivationCode() {
  final code = StringBuffer();
  for (var i = 0; i < 6; i++) {
    code.write(
      String.fromCharCode(65 + DateTime.now().microsecondsSinceEpoch % 26),
    );
  }
  return code.toString().toUpperCase();
}
