import 'dart:convert';

List<GoogleAddressModel> googleAddressModelFromJson(String str) =>
    List<GoogleAddressModel>.from(
        json.decode(str).map((x) => GoogleAddressModel.fromJson(x)));

String googleAddressModelToJson(List<GoogleAddressModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GoogleAddressModel {
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? placeId;
  final String? description;

  GoogleAddressModel({
    this.address,
    this.latitude,
    this.longitude,
    this.placeId,
    this.description,
  });

  factory GoogleAddressModel.fromJson(Map<String, dynamic> json) =>
      GoogleAddressModel(
        address: json["address"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        placeId: json["place_id"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "place_id": placeId,
        "description": description,
      };
}
