import 'dart:convert';

List<StateModel> stateModelFromJson(String str) =>
    List<StateModel>.from(json.decode(str).map((x) => StateModel.fromJson(x)));

class StateModel {
  final int? id;
  final String? name;
  final int? countryId;
  final String? countryCode;
  final String? fipsCode;
  final String? iso2;
  final String? type;
  final dynamic level;
  final dynamic parentId;
  final String? latitude;
  final String? longitude;
  final int? flag;
  final String? wikiDataId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StateModel({
    this.id,
    this.name,
    this.countryId,
    this.countryCode,
    this.fipsCode,
    this.iso2,
    this.type,
    this.level,
    this.parentId,
    this.latitude,
    this.longitude,
    this.flag,
    this.wikiDataId,
    this.createdAt,
    this.updatedAt,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
        id: json["id"],
        name: json["name"],
        countryId: json["country_id"],
        countryCode: json["country_code"],
        fipsCode: json["fips_code"],
        iso2: json["iso2"],
        type: json["type"],
        level: json["level"],
        parentId: json["parent_id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        flag: json["flag"],
        wikiDataId: json["wikiDataId"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}
