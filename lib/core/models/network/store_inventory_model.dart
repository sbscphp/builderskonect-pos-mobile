import 'dart:convert';

import 'package:builders_konnect/core/models/network/store_location_model.dart';

StoreInventoryModel storeInventoryModelFromJson(String str) =>
    StoreInventoryModel.fromJson(json.decode(str));

String storeInventoryModelToJson(StoreInventoryModel data) =>
    json.encode(data.toJson());

class StoreInventoryModel {
  final String? id;
  final String? storeId;
  final String? name;
  final String? address;
  final int? totalCustomers;
  final int? totalProducts;
  final double? totalSales;
  final int? totalStaff;
  final DateTime? dateCreated;
  final String? status;
  final Products? products;

  StoreInventoryModel({
    this.id,
    this.storeId,
    this.name,
    this.address,
    this.totalCustomers,
    this.totalProducts,
    this.totalSales,
    this.totalStaff,
    this.dateCreated,
    this.status,
    this.products,
  });

  factory StoreInventoryModel.fromJson(Map<String, dynamic> json) =>
      StoreInventoryModel(
        id: json["id"],
        storeId: json["storeID"],
        name: json["name"],
        address: json["address"],
        totalCustomers: json["total_customers"],
        totalProducts: json["total_products"],
        totalSales: json["total_sales"]?.toDouble(),
        totalStaff: json["total_staff"],
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        status: json["status"],
        products: json["products"] == null
            ? null
            : Products.fromJson(json["products"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "storeID": storeId,
        "name": name,
        "address": address,
        "total_customers": totalCustomers,
        "total_products": totalProducts,
        "total_sales": totalSales,
        "total_staff": totalStaff,
        "date_created": dateCreated?.toIso8601String(),
        "status": status,
        "products": products?.toJson(),
      };
}

class Products {
  final int? currentPage;
  final List<ProductData>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link>? links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  Products({
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

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<ProductData>.from(
                json["data"]!.map((x) => ProductData.fromJson(x))),
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

class ProductData {
  final String? id;
  final String? name;
  final String? sku;
  final String? primaryMediaUrl;
  final String? dateAdded;
  final int? quantity;
  final String? status;

  ProductData({
    this.id,
    this.name,
    this.sku,
    this.primaryMediaUrl,
    this.dateAdded,
    this.quantity,
    this.status,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        id: json["id"],
        name: json["name"],
        sku: json["SKU"],
        primaryMediaUrl: json["primary_media_url"],
        dateAdded: json["date_added"],
        quantity: json["quantity"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "SKU": sku,
        "primary_media_url": primaryMediaUrl,
        "date_added": dateAdded,
        "quantity": quantity,
        "status": status,
      };
}
