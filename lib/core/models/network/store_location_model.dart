import 'dart:convert';

StoreLocationModel storeLocationModelFromJson(String str) =>
    StoreLocationModel.fromJson(json.decode(str));

String storeLocationModelToJson(StoreLocationModel data) =>
    json.encode(data.toJson());

class StoreLocationModel {
  final Stats? stats;
  final Data? data;

  StoreLocationModel({
    this.stats,
    this.data,
  });

  factory StoreLocationModel.fromJson(Map<String, dynamic> json) =>
      StoreLocationModel(
        stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "stats": stats?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  final int? currentPage;
  final List<StoreModel>? data;
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

  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<StoreModel>.from(
                json["data"]!.map((x) => StoreModel.fromJson(x))),
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

List<StoreModel> storeModelFromJson(String str) =>
    List<StoreModel>.from(json.decode(str).map((x) => StoreModel.fromJson(x)));

class StoreModel {
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

  StoreModel({
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
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
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
      };
}

class Link {
  final String? url;
  final String? label;
  final bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}

class Stats {
  final int? total;
  final int? active;
  final int? inactive;

  Stats({
    this.total,
    this.active,
    this.inactive,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        total: json["total"],
        active: json["active"],
        inactive: json["inactive"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "active": active,
        "inactive": inactive,
      };
}
