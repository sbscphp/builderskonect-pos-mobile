import 'dart:convert';

List<ProductAttributeModel> productAttributeModelFromJson(String str) =>
    List<ProductAttributeModel>.from(
        json.decode(str).map((x) => ProductAttributeModel.fromJson(x)));

class ProductAttributeModel {
  final String? id;
  final String? attribute;
  final List<String>? possibleValues;
  final String? category;

  ProductAttributeModel(
      {this.id, this.attribute, this.possibleValues, this.category});

  factory ProductAttributeModel.fromJson(Map<String, dynamic> json) =>
      ProductAttributeModel(
        id: json['id'],
        attribute: json['attribute'],
        possibleValues: json['possible_values'] != null
            ? List.from(json['possible_values'])
            : null,
        category: json['category'],
      );

  toJson() => {
        "id": id,
        "attribute": attribute,
        "possible_values": possibleValues,
        "category": category
      };
}
