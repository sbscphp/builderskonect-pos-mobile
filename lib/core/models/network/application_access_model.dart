import 'dart:convert';

List<ApplicationAccessModel> applicationAccessModelFromJson(String str) =>
    List<ApplicationAccessModel>.from(
        json.decode(str).map((x) => ApplicationAccessModel.fromJson(x)));

class ApplicationAccessModel {
  final String? name;
  final String? tag;
  final bool? access;

  ApplicationAccessModel({
    this.name,
    this.tag,
    this.access,
  });

  factory ApplicationAccessModel.fromJson(Map<String, dynamic> json) =>
      ApplicationAccessModel(
        name: json["name"],
        tag: json["tag"],
        access: json["access"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "tag": tag,
        "access": access,
      };
}
