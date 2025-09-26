import 'dart:convert';

List<BrandModel> brandModelFromJson(String str) =>
    List<BrandModel>.from(json.decode(str).map((x) => BrandModel.fromJson(x)));

class BrandModel {
  final int? id;
  final String? name;
  final dynamic isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BrandModel({
    this.id,
    this.name,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
        id: json["id"],
        name: json["name"],
        isActive: json["is_active"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
