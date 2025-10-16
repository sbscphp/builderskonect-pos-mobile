import 'dart:convert';

import 'package:builders_konnect/core/models/network/store_location_model.dart';

InventoryProductModel inventoryProductModelFromJson(String str) =>
    InventoryProductModel.fromJson(json.decode(str));

String inventoryProductModelToJson(InventoryProductModel data) =>
    json.encode(data.toJson());

class InventoryProductModel {
  final ProductStats? stats;
  final InventoryResponse? data;

  InventoryProductModel({
    this.stats,
    this.data,
  });

  factory InventoryProductModel.fromJson(Map<String, dynamic> json) =>
      InventoryProductModel(
        stats:
            json["stats"] == null ? null : ProductStats.fromJson(json["stats"]),
        data: json["data"] == null
            ? null
            : InventoryResponse.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "stats": stats?.toJson(),
        "data": data?.toJson(),
      };
}

class InventoryResponse {
  final int? currentPage;
  final List<ProductModel>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link>? links;
  final dynamic nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  InventoryResponse({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory InventoryResponse.fromJson(Map<String, dynamic> json) =>
      InventoryResponse(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<ProductModel>.from(
                json["data"]!.map((x) => ProductModel.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

List<ProductModel> inventoryProductListFromJson(String str) =>
    List<ProductModel>.from(
        json.decode(str).map((x) => ProductModel.fromJson(x)));

class ProductModel {
  final String? id;
  final String? name;
  final String? sku;
  final String? ean;
  final String? code;
  final String? category;
  final String? categoryId;
  final String? subcategory;
  final String? subcategoryId;
  final String? productType;
  final String? productTypeId;
  final String? retailPrice;
  final String? brand;
  final String? costPrice;
  final String? currentPrice;
  final InventoryMetadata? metadata;
  final DateTime? dateAdded;
  final String? description;
  final String? tags;
  final String? status;
  final int? quantity;
  final String? measurementUnit;
  final dynamic dimension;
  final dynamic weight;
  final String? reorderValue;
  final String? primaryMediaUrl;
  final List<String>? media;
  final dynamic attributes;
  final num? ratings;
  final num? totalReviews;
  int? requestQuantity;
  TransferItemDetails? transferItemDetails;

  ProductModel(
      {this.id,
      this.name,
      this.sku,
      this.ean,
      this.code,
      this.category,
      this.categoryId,
      this.subcategory,
      this.subcategoryId,
      this.productType,
      this.productTypeId,
      this.retailPrice,
      this.brand,
      this.costPrice,
      this.currentPrice,
      this.metadata,
      this.dateAdded,
      this.description,
      this.tags,
      this.status,
      this.quantity,
      this.measurementUnit,
      this.dimension,
      this.weight,
      this.reorderValue,
      this.primaryMediaUrl,
      this.media,
      this.attributes,
      this.ratings,
      this.totalReviews});

  // ProductModel copywith
  ProductModel copyWith({
    String? id,
    String? name,
    String? sku,
    String? ean,
    String? code,
    String? category,
    String? categoryId,
    String? subcategory,
    String? subcategoryId,
    String? productType,
    String? productTypeId,
    String? retailPrice,
    String? brand,
    String? costPrice,
    String? currentPrice,
    InventoryMetadata? metadata,
    DateTime? dateAdded,
    String? description,
    String? tags,
    String? status,
    int? quantity,
    String? measurementUnit,
    dynamic dimension,
    dynamic weight,
    String? reorderValue,
    String? primaryMediaUrl,
    List<String>? media,
    dynamic attributes,
    num? ratings,
    num? totalReviews,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      ean: ean ?? this.ean,
      code: code ?? this.code,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      subcategory: subcategory ?? this.subcategory,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      productType: productType ?? this.productType,
      productTypeId: productTypeId ?? this.productTypeId,
      retailPrice: retailPrice ?? this.retailPrice,
      brand: brand ?? this.brand,
      costPrice: costPrice ?? this.costPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      metadata: metadata ?? this.metadata,
      dateAdded: dateAdded ?? this.dateAdded,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      quantity: quantity ?? this.quantity,
      measurementUnit: measurementUnit ?? this.measurementUnit,
      dimension: dimension ?? this.dimension,
      weight: weight ?? this.weight,
      reorderValue: reorderValue ?? this.reorderValue,
      primaryMediaUrl: primaryMediaUrl ?? this.primaryMediaUrl,
      media: media ?? this.media,
      attributes: attributes ?? this.attributes,
      ratings: ratings ?? this.ratings,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        sku: json["SKU"],
        ean: json["ean"],
        code: json["code"],
        category: json["category"],
        categoryId: json["category_id"],
        subcategory: json["subcategory"],
        subcategoryId: json["subcategory_id"],
        productType: json["product_type"],
        productTypeId: json["product_type_id"],
        retailPrice: json["retail_price"],
        brand: json["brand"],
        costPrice: json["cost_price"],
        currentPrice: json["current_price"],
        metadata: json["metadata"] == null
            ? null
            : InventoryMetadata.fromJson(json["metadata"]),
        dateAdded: json["date_added"] == null
            ? null
            : DateTime.parse(json["date_added"]),
        description: json["description"],
        tags: json["tags"],
        status: json["status"],
        quantity: json["quantity"],
        measurementUnit: json["measurement_unit"],
        dimension: json["dimension"],
        weight: json["weight"],
        reorderValue: json["reorder_value"],
        primaryMediaUrl: json["primary_media_url"],
        media: json["media"] == null
            ? []
            : List<String>.from(json["media"]!.map((x) => x)),
        attributes: json["attributes"],
        ratings: json["ratings"] is String
            ? double.tryParse(json["ratings"]) ?? 0.0
            : json["ratings"],
        totalReviews: json["total_reviews"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "SKU": sku,
        "ean": ean,
        "code": code,
        "category": category,
        "category_id": categoryId,
        "subcategory": subcategory,
        "subcategory_id": subcategoryId,
        "product_type": productType,
        "product_type_id": productTypeId,
        "retail_price": retailPrice,
        "brand": brand,
        "cost_price": costPrice,
        "current_price": currentPrice,
        "metadata": metadata?.toJson(),
        "date_added": dateAdded?.toIso8601String(),
        "description": description,
        "tags": tags,
        "status": status,
        "quantity": quantity,
        "measurement_unit": measurementUnit,
        "dimension": dimension,
        "weight": weight,
        "reorder_value": reorderValue,
        "primary_media_url": primaryMediaUrl,
        "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x)),
        "attributes": attributes,
        "ratings": ratings,
        "total_reviews": totalReviews,
        "productItem": transferItemDetails?.toJson()
      };
}

// class AttributesClass {
//   final List<String>? type;
//   final List<String>? safetyGear;

//   AttributesClass({
//     this.type,
//     this.safetyGear,
//   });

//   factory AttributesClass.fromJson(Map<String, dynamic> json) =>
//       AttributesClass(
//         type: json["Type"] == null
//             ? []
//             : List<String>.from(json["Type"]!.map((x) => x)),
//         safetyGear: json["Safety Gear"] == null
//             ? []
//             : List<String>.from(json["Safety Gear"]!.map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "Type": type == null ? [] : List<dynamic>.from(type!.map((x) => x)),
//         "Safety Gear": safetyGear == null
//             ? []
//             : List<dynamic>.from(safetyGear!.map((x) => x)),
//       };
// }

class DimensionClass {
  final String? length;
  final String? width;
  final String? height;

  DimensionClass({
    this.length,
    this.width,
    this.height,
  });

  factory DimensionClass.fromJson(Map<String, dynamic> json) => DimensionClass(
        length: json["length"],
        width: json["width"],
        height: json["height"],
      );

  Map<String, dynamic> toJson() => {
        "length": length,
        "width": width,
        "height": height,
      };
}

class InventoryMetadata {
  final dynamic attributes;

  InventoryMetadata({
    this.attributes,
  });

  factory InventoryMetadata.fromJson(Map<String, dynamic> json) =>
      InventoryMetadata(attributes: json["attributes"]);

  Map<String, dynamic> toJson() => {"attributes": attributes};
}

class WeightClass {
  final String? value;
  final String? unit;

  WeightClass({
    this.value,
    this.unit,
  });

  factory WeightClass.fromJson(Map<String, dynamic> json) => WeightClass(
        value: json["value"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "unit": unit,
      };
}

class ProductStats {
  final dynamic totalProducts;
  final double? totalProductsValue;
  final dynamic totalSoldProducts;
  final dynamic lowStockProducts;
  final dynamic availableProducts;
  final dynamic totalSales;

  ProductStats({
    this.totalProducts,
    this.totalProductsValue,
    this.totalSoldProducts,
    this.lowStockProducts,
    this.availableProducts,
    this.totalSales,
  });

  factory ProductStats.fromJson(Map<String, dynamic> json) => ProductStats(
        totalProducts: json["total_products"],
        totalProductsValue: json["total_products_value"]?.toDouble(),
        totalSoldProducts: json["total_sold_products"],
        lowStockProducts: json["low_stock_products"],
        availableProducts: json["available_products"],
        totalSales: json["total_sales"],
      );

  Map<String, dynamic> toJson() => {
        "total_products": totalProducts,
        "total_products_value": totalProductsValue,
        "total_sold_products": totalSoldProducts,
        "low_stock_products": lowStockProducts,
        "available_products": availableProducts,
        "total_sales": totalSales,
      };
}

TransferItemDetails transferItemDetailsFromJson(String str) =>
    TransferItemDetails.fromJson(json.decode(str));

class TransferItemDetails {
  String? id;
  String? name;
  String? primaryImage;
  String? sku;
  int? sourceQty;
  int? destinyQty;

  TransferItemDetails(
      {this.id,
      this.name,
      this.primaryImage,
      this.sku,
      this.sourceQty,
      this.destinyQty});

  factory TransferItemDetails.fromJson(Map<String, dynamic> json) =>
      TransferItemDetails(
          id: json['id'],
          name: json['name'],
          primaryImage: json['primary_image'],
          sku: json['SKU'],
          sourceQty: json['source_quantity'],
          destinyQty: json['destination_quantity']);

  toJson() => {
        "id": id,
        "name": name,
        "primary_image": primaryImage,
        "SKU": sku,
        "source_quantity": sourceQty,
        "destination_quantity": destinyQty
      };
}
