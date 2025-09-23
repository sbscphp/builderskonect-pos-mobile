import 'dart:convert';

List<ReturnDataModel> returnDataFromJson(String str) =>
    List<ReturnDataModel>.from(
        json.decode(str).map((x) => ReturnDataModel.fromJson(x)));

ReturnStats returnStatsFromJson(String str) =>
    ReturnStats.fromJson(json.decode(str));

String returnDataToJson(List<ReturnDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReturnDataModel {
  final String? id;
  final String? productName;
  final String? productSku;
  final DateTime? dateReturned;
  final String? orderID;
  final dynamic totalAmountRefunded;
  final String? customerName;
  final String? customerEmail;
  final String? status;

  ReturnDataModel(
      {this.id,
      this.productName,
      this.productSku,
      this.dateReturned,
      this.orderID,
      this.totalAmountRefunded,
      this.customerEmail,
      this.customerName,
      this.status});

  factory ReturnDataModel.fromJson(Map<String, dynamic> json) =>
      ReturnDataModel(
        id: json['id'],
        productName: json['product_name'],
        productSku: json['product_sku'],
        dateReturned: json['date_returned'] != null
            ? DateTime.parse(json['date_returned'])
            : null,
        orderID: json['orderID'],
        totalAmountRefunded: json['total_amount_refunded'],
        customerName: json['customer_name'],
        customerEmail: json['customer_email'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_name": productName,
        "product_sku": productSku,
        "date_returned": dateReturned?.toIso8601String(),
        "orderID": orderID,
        "total_amount_refunded": totalAmountRefunded,
        "customer_name": customerName,
        "customer_email": customerEmail,
        "status": status
      };
}

class ReturnStats {
  final int? totalReturns;
  final dynamic totalRefundValue;
  final int? cancelledRequest;
  final int? approvedRequest;

  ReturnStats(
      {this.totalReturns,
      this.totalRefundValue,
      this.cancelledRequest,
      this.approvedRequest});

  factory ReturnStats.fromJson(Map<String, dynamic> json) => ReturnStats(
      totalReturns: json['total_returns'],
      totalRefundValue: json['total_refund_value'],
      cancelledRequest: json['cancelled_request'],
      approvedRequest: json['approved_request']);
}
