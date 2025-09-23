import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) =>
    List<CategoryModel>.from(
        json.decode(str).map((x) => CategoryModel.fromJson(x)));

class CategoryModel {
  final String? id;
  final String? name;
  final String? slug;
  final int? isActive;
  final String? table;
  final String? level;
  final String? parentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryModel({
    this.id,
    this.name,
    this.slug,
    this.isActive,
    this.table,
    this.level,
    this.parentId,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        isActive: json["is_active"],
        table: json["table"],
        level: json["level"],
        parentId: json["parent_id"],
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
        "slug": slug,
        "is_active": isActive,
        "table": table,
        "level": level,
        "parent_id": parentId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
