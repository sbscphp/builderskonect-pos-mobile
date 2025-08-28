import 'dart:convert';

import 'package:builders_konnect/core/models/network/store_location_model.dart';
import 'package:builders_konnect/core/models/network/store_overview_model.dart';

SalesOverviewModel salesOverviewModelFromJson(String str) =>
    SalesOverviewModel.fromJson(json.decode(str));

class SalesOverviewModel {
  final SalesStats? stats;
  final SalesResponseData? data;

  SalesOverviewModel({
    this.stats,
    this.data,
  });

  factory SalesOverviewModel.fromJson(Map<String, dynamic> json) =>
      SalesOverviewModel(
        stats:
            json["stats"] == null ? null : SalesStats.fromJson(json["stats"]),
        data: json["data"] == null
            ? null
            : SalesResponseData.fromJson(json["data"]),
      );
}

class SalesResponseData {
  final int? currentPage;
  final List<SalesData>? data;
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

  SalesResponseData({
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

  factory SalesResponseData.fromJson(Map<String, dynamic> json) =>
      SalesResponseData(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<SalesData>.from(
                json["data"]!.map((x) => SalesData.fromJson(x))),
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

class SalesData {
  final String? id;
  final String? orderNumber;
  final String? receiptNo;
  final int? itemsCount;
  final Customer? customer;
  final DateTime? date;
  final DateTime? orderDate;
  final String? amount;
  final String? paymentStatus;
  final String? status;
  final String? salesType;

  SalesData({
    this.id,
    this.orderNumber,
    this.receiptNo,
    this.itemsCount,
    this.customer,
    this.date,
    this.orderDate,
    this.amount,
    this.paymentStatus,
    this.status,
    this.salesType,
  });

  factory SalesData.fromJson(Map<String, dynamic> json) => SalesData(
        id: json["id"],
        orderNumber: json["order_number"],
        receiptNo: json["receipt_no"],
        itemsCount: json["items_count"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        orderDate: json["order_date"] == null
            ? null
            : DateTime.parse(json["order_date"]),
        amount: json["amount"],
        paymentStatus: json["payment_status"],
        status: json["status"],
        salesType: json["sales_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_number": orderNumber,
        "receipt_no": receiptNo,
        "items_count": itemsCount,
        "customer": customer?.toJson(),
        "date": date?.toIso8601String(),
        "order_date": orderDate?.toIso8601String(),
        "amount": amount,
        "payment_status": paymentStatus,
        "status": status,
        "sales_type": salesType,
      };
}

class SalesStats {
  final int? totalSales;
  final String? totalSalesValue;
  final String? onlineSales;
  final String? offlineSales;
  final num? onlineSalesVolume;
  final num? offlineSalesVolume;
  final String? conversionRate;

  SalesStats({
    this.totalSales,
    this.totalSalesValue,
    this.onlineSales,
    this.offlineSales,
    this.onlineSalesVolume,
    this.offlineSalesVolume,
    this.conversionRate,
  });

  factory SalesStats.fromJson(Map<String, dynamic> json) => SalesStats(
        totalSales: json["total_sales"],
        totalSalesValue: json["total_sales_value"],
        onlineSales: json["online_sales"],
        offlineSales: json["offline_sales"],
        onlineSalesVolume: json["online_sales_volume"],
        offlineSalesVolume: json["offline_sales_volume"],
        conversionRate: json["conversion_rate"],
      );
}
