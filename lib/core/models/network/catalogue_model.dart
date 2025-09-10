import 'dart:convert';

List<CatalogueModel> catalogueModelFromJson(String str) =>
    List<CatalogueModel>.from(
        json.decode(str).map((x) => CatalogueModel.fromJson(x)));

String catalogueModelToJson(List<CatalogueModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CatalogueModel {
  final String? id;
  final String? name;
  final String? code;
  final String? sku;
  final Category? category;
  final Category? subcategory;
  final Category? productType;
  final String? brand;
  final String? description;
  final String? tags;
  final DateTime? dateAdded;
  final String? primaryMediaUrl;
  final List<String>? media;
  final Map<String, List<String>>? attributes;
  final PhysicalDimension? weightPerUnitItem;
  final int? quantityPerSellingUnit;
  final dynamic weightPerSellingUnit;
  final dynamic minimumOrderQuantity;
  final List<String>? shippingClasses;
  final PhysicalDimension? physicalMeasurementUnit;
  final PhysicalDimension? physicalDimension;
  final String? sellingUnit;

  CatalogueModel({
    this.id,
    this.name,
    this.code,
    this.sku,
    this.category,
    this.subcategory,
    this.productType,
    this.brand,
    this.description,
    this.tags,
    this.dateAdded,
    this.primaryMediaUrl,
    this.media,
    this.attributes,
    this.weightPerUnitItem,
    this.quantityPerSellingUnit,
    this.weightPerSellingUnit,
    this.minimumOrderQuantity,
    this.shippingClasses,
    this.physicalMeasurementUnit,
    this.physicalDimension,
    this.sellingUnit,
  });

  factory CatalogueModel.fromJson(Map<String, dynamic> json) => CatalogueModel(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        sku: json["SKU"],
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        subcategory: json["subcategory"] == null
            ? null
            : Category.fromJson(json["subcategory"]),
        productType: json["product_type"] == null
            ? null
            : Category.fromJson(json["product_type"]),
        brand: json["brand"],
        description: json["description"],
        tags: json["tags"],
        dateAdded: json["date_added"] == null
            ? null
            : DateTime.parse(json["date_added"]),
        primaryMediaUrl: json["primary_media_url"],
        media: json["media"] == null
            ? []
            : List<String>.from(json["media"]!.map((x) => x)),
        attributes: Map.from(json["attributes"]!).map((k, v) =>
            MapEntry<String, List<String>>(
                k, List<String>.from(v.map((x) => x)))),
        weightPerUnitItem: json["weight_per_unit_item"] == null
            ? null
            : PhysicalDimension.fromJson(json["weight_per_unit_item"]),
        quantityPerSellingUnit: json["quantity_per_selling_unit"],
        weightPerSellingUnit: json["weight_per_selling_unit"],
        minimumOrderQuantity: json["minimum_order_quantity"],
        shippingClasses: json["shipping_classes"] == null
            ? []
            : List<String>.from(json["shipping_classes"]!.map((x) => x)),
        physicalMeasurementUnit: json["physical_measurement_unit"] == null
            ? null
            : PhysicalDimension.fromJson(json["physical_measurement_unit"]),
        physicalDimension: json["physical_dimension"] == null
            ? null
            : PhysicalDimension.fromJson(json["physical_dimension"]),
        sellingUnit: json["selling_unit"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "SKU": sku,
        "category": category?.toJson(),
        "subcategory": subcategory?.toJson(),
        "product_type": productType?.toJson(),
        "brand": brand,
        "description": description,
        "tags": tags,
        "date_added": dateAdded?.toIso8601String(),
        "primary_media_url": primaryMediaUrl,
        "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x)),
        "attributes": Map.from(attributes!).map((k, v) =>
            MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
        "weight_per_unit_item": weightPerUnitItem?.toJson(),
        "quantity_per_selling_unit": quantityPerSellingUnit,
        "weight_per_selling_unit": weightPerSellingUnit,
        "minimum_order_quantity": minimumOrderQuantity,
        "shipping_classes": shippingClasses == null
            ? []
            : List<dynamic>.from(shippingClasses!.map((x) => x)),
        "physical_measurement_unit": physicalMeasurementUnit?.toJson(),
        "physical_dimension": physicalDimension?.toJson(),
        "selling_unit": sellingUnit,
      };
}

class Category {
  final String? id;
  final String? name;

  Category({
    this.id,
    this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class PhysicalDimension {
  final String? unit;
  final int? value;

  PhysicalDimension({
    this.unit,
    this.value,
  });

  factory PhysicalDimension.fromJson(Map<String, dynamic> json) =>
      PhysicalDimension(
        unit: json["unit"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "unit": unit,
        "value": value,
      };
}
