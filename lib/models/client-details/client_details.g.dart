// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientDetails _$ClientDetailsFromJson(Map<String, dynamic> json) =>
    ClientDetails(
      fullName: json['fullName'] as String,
      address: json['address'] as String,
      geoPoint: json['geoPoint'] as GeoPoint,
    );

Map<String, dynamic> _$ClientDetailsToJson(ClientDetails instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'address': instance.address,
      'geoPoint': instance.geoPoint,
    };
