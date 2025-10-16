import 'dart:convert';

List<RefundData> refundDataFromJson(String str) =>
    List<RefundData>.from(json.decode(str).map((x) => RefundData.fromJson(x)));

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

RefundStats? refundStatsFromJson(String str) =>
    RefundStats.fromJson(json.decode(str));

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
        totalRefundValue: json["total_refund_value"] is String
            ? json["total_refund_value"]
            : json["total_refund_value"]?.toString(),
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
