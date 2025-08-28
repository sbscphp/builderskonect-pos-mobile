import 'dart:convert';

import 'package:builders_konnect/core/models/network/store_location_model.dart';

CustomerOverviewModel customerOverviewModelFromJson(String str) =>
    CustomerOverviewModel.fromJson(json.decode(str));

String customerOverviewModelToJson(CustomerOverviewModel data) =>
    json.encode(data.toJson());

class CustomerOverviewModel {
  final CustomerStats? stats;
  final CustomerResponseData? data;

  CustomerOverviewModel({
    this.stats,
    this.data,
  });

  factory CustomerOverviewModel.fromJson(Map<String, dynamic> json) =>
      CustomerOverviewModel(
        stats: json["stats"] == null
            ? null
            : CustomerStats.fromJson(json["stats"]),
        data: json["data"] == null
            ? null
            : CustomerResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "stats": stats?.toJson(),
        "data": data?.toJson(),
      };
}

class CustomerResponseData {
  final int? currentPage;
  final List<CustomerData>? data;
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

  CustomerResponseData({
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

  factory CustomerResponseData.fromJson(Map<String, dynamic> json) =>
      CustomerResponseData(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<CustomerData>.from(
                json["data"]!.map((x) => CustomerData.fromJson(x))),
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

class CustomerData {
  final String? id;
  final String? customerId;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? channel;
  final String? source;
  final DateTime? dateJoined;

  CustomerData({
    this.id,
    this.customerId,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.channel,
    this.source,
    this.dateJoined,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) => CustomerData(
        id: json["id"],
        customerId: json["customerID"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
        channel: json["channel"],
        source: json["source"],
        dateJoined: json["date_joined"] == null
            ? null
            : DateTime.parse(json["date_joined"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customerID": customerId,
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
        "channel": channel,
        "source": source,
        "date_joined": dateJoined?.toIso8601String(),
      };
}

class CustomerStats {
  final int? total;
  final int? online;
  final int? offline;

  CustomerStats({
    this.total,
    this.online,
    this.offline,
  });

  factory CustomerStats.fromJson(Map<String, dynamic> json) => CustomerStats(
        total: json["total"],
        online: json["online"],
        offline: json["offline"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "online": online,
        "offline": offline,
      };
}
