import 'dart:convert';

List<BusinessCategoryTypeModel> businessCategoryTypeModelFromJson(String str) =>
    List<BusinessCategoryTypeModel>.from(
        json.decode(str).map((x) => BusinessCategoryTypeModel.fromJson(x)));

class BusinessCategoryTypeModel {
  final String? id;
  final String? name;
  final String? slug;
  final int? isActive;
  final bool? archive;
  final String? table;
  final dynamic mediaUrl;
  final String? level;
  final dynamic metadata;
  final dynamic parentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BusinessCategoryTypeModel({
    this.id,
    this.name,
    this.slug,
    this.isActive,
    this.archive,
    this.table,
    this.mediaUrl,
    this.level,
    this.metadata,
    this.parentId,
    this.createdAt,
    this.updatedAt,
  });

  factory BusinessCategoryTypeModel.fromJson(Map<String, dynamic> json) =>
      BusinessCategoryTypeModel(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        isActive: json["is_active"],
        archive: json["archive"],
        table: json["table"],
        mediaUrl: json["media_url"],
        level: json["level"],
        metadata: json["metadata"],
        parentId: json["parent_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}
