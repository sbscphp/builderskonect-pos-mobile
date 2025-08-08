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

  GoogleAddressModel({
    this.address,
    this.latitude,
    this.longitude,
  });

  factory GoogleAddressModel.fromJson(Map<String, dynamic> json) =>
      GoogleAddressModel(
        address: json["address"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
      };
}
