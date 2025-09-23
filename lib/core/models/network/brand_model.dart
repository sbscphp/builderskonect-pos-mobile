import 'dart:convert';

List<BrandModel> brandModelFromJson(String str) =>
    List<BrandModel>.from(json.decode(str).map((x) => BrandModel.fromJson(x)));

class BrandModel {
  final int? id;
  final String? name;
  final int? isActive;

  BrandModel({
    this.id,
    this.name,
    this.isActive,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
        id: json["id"],
        name: json["name"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_active": isActive,
      };
}
