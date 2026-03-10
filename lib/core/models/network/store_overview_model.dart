import 'dart:convert';

import 'package:builders_konnect/core/models/network/store_location_model.dart';

StoreOverviewModel storeOverviewModelFromJson(String str) =>
    StoreOverviewModel.fromJson(json.decode(str));

class StoreOverviewModel {
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
  final double? totalSalesValue;
  final int? completed;
  final int? processing;
  final int? cancelled;
  final dynamic salesOverview;

  StoreOverviewModel({
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
    this.totalSalesValue,
    this.completed,
    this.processing,
    this.cancelled,
    this.salesOverview,
  });

  factory StoreOverviewModel.fromJson(Map<String, dynamic> json) =>
      StoreOverviewModel(
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
        totalSalesValue: json["total_sales_value"]?.toDouble(),
        completed: json["completed"],
        processing: json["processing"],
        cancelled: json["cancelled"],
        salesOverview: json["sales_overview"] == null
            ? null
            : json["sales_overview"]?.runtimeType == List
                ? null
                : SalesOverview.fromJson(json["sales_overview"]),
      );
}

class SalesOverview {
  final int? currentPage;
  final List<Datum>? data;
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

  SalesOverview({
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

  factory SalesOverview.fromJson(Map<String, dynamic> json) => SalesOverview(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
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
}

class Datum {
  final String? id;
  final String? orderNumber;
  final int? itemsCount;
  final Customer? customer;
  final DateTime? date;
  final String? amount;
  final String? status;

  Datum({
    this.id,
    this.orderNumber,
    this.itemsCount,
    this.customer,
    this.date,
    this.amount,
    this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        orderNumber: json["order_number"],
        itemsCount: json["items_count"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        amount: json["amount"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_number": orderNumber,
        "items_count": itemsCount,
        "customer": customer?.toJson(),
        "date": date?.toIso8601String(),
        "amount": amount,
        "status": status,
      };
}

class Customer {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final dynamic referralSource;

  Customer({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.referralSource,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        referralSource: json["referral_source"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "referral_source": referralSource,
      };
}
