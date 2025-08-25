import 'dart:convert';

List<RoleModel> roleModelListFromJson(String str) =>
    List.from(json.decode(str)).map((e) => RoleModel.fromJson(e)).toList();

class RoleModel {
  final int? id;
  final String? name;
  final String? description;
  final bool? isActive;
  final bool? isEditable;

  RoleModel(
      {this.id, this.name, this.description, this.isActive, this.isEditable});
  
  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
    id: json["id"],
    name: json["name"],
    description: json["descriprion"],
    isActive: json["is_active"],
    isEditable: json["is_editable"],
  );
}
