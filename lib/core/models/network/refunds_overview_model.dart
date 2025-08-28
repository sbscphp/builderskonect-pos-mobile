import 'dart:convert';

import 'package:builders_konnect/core/models/network/store_location_model.dart';

RefundsOverviewModel refundsOverviewModelFromJson(String str) =>
    RefundsOverviewModel.fromJson(json.decode(str));

String refundsOverviewModelToJson(RefundsOverviewModel data) =>
    json.encode(data.toJson());

class RefundsOverviewModel {
  final RefundStats? stats;
  final ResonseData? data;

  RefundsOverviewModel({
    this.stats,
    this.data,
  });

  factory RefundsOverviewModel.fromJson(Map<String, dynamic> json) =>
      RefundsOverviewModel(
        stats:
            json["stats"] == null ? null : RefundStats.fromJson(json["stats"]),
        data: json["data"] == null ? null : ResonseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "stats": stats?.toJson(),
        "data": data?.toJson(),
      };
}

class ResonseData {
  final int? currentPage;
  final List<RefundData>? data;
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

  ResonseData({
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

  factory ResonseData.fromJson(Map<String, dynamic> json) => ResonseData(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<RefundData>.from(
                json["data"]!.map((x) => RefundData.fromJson(x))),
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

class RefundData {
  final String? id;
  final String? productImage;
  final String? productName;
  final String? productSku;
  final DateTime? dateReturned;
  final String? orderId;
  final String? totalAmountRefunded;
  final String? customerName;
  final String? customerEmail;
  final String? status;

  RefundData({
    this.id,
    this.productImage,
    this.productName,
    this.productSku,
    this.dateReturned,
    this.orderId,
    this.totalAmountRefunded,
    this.customerName,
    this.customerEmail,
    this.status,
  });

  factory RefundData.fromJson(Map<String, dynamic> json) => RefundData(
        id: json["id"],
        productImage: json["product_image"],
        productName: json["product_name"],
        productSku: json["product_sku"],
        dateReturned: json["date_returned"] == null
            ? null
            : DateTime.parse(json["date_returned"]),
        orderId: json["orderID"],
        totalAmountRefunded: json["total_amount_refunded"],
        customerName: json["customer_name"],
        customerEmail: json["customer_email"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_image": productImage,
        "product_name": productName,
        "product_sku": productSku,
        "date_returned": dateReturned?.toIso8601String(),
        "orderID": orderId,
        "total_amount_refunded": totalAmountRefunded,
        "customer_name": customerName,
        "customer_email": customerEmail,
        "status": status,
      };
}

class RefundStats {
  final int? totalReturns;
  final String? totalRefundValue;
  final int? cancelledRequest;
  final int? approvedRequest;

  RefundStats({
    this.totalReturns,
    this.totalRefundValue,
    this.cancelledRequest,
    this.approvedRequest,
  });

  factory RefundStats.fromJson(Map<String, dynamic> json) => RefundStats(
        totalReturns: json["total_returns"],
        totalRefundValue: json["total_refund_value"],
        cancelledRequest: json["cancelled_request"],
        approvedRequest: json["approved_request"],
      );

  Map<String, dynamic> toJson() => {
        "total_returns": totalReturns,
        "total_refund_value": totalRefundValue,
        "cancelled_request": cancelledRequest,
        "approved_request": approvedRequest,
      };
}
