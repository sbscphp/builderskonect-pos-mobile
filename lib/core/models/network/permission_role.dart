import 'dart:convert';

List<PermissionRole> permissionRolesFromJson(String str) =>
    List.from(json.decode(str)).map((e) => PermissionRole.fromJson(e)).toList();

class PermissionRole {
  final int? id;
  final String? name;
  final String? module;
  final String? description;
  final String? subModule;

  PermissionRole({
    this.id,
    this.name,
    this.module,
    this.description,
    this.subModule
  });

  factory PermissionRole.fromJson(Map<String, dynamic> json) => PermissionRole(
    id: json["id"],
    name: json["name"],
    module: json["module"],
    description: json["description"],
    subModule: json["sub_module"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "module": module,
    "description": description,
    "sub_module": subModule,
  };
}