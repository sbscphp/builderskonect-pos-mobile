import 'dart:convert';

import 'package:builders_konnect/core/models/network/store_overview_model.dart';

List<PausedSalesModel> pausedSalesModelFromJson(String str) =>
    List<PausedSalesModel>.from(
        json.decode(str).map((x) => PausedSalesModel.fromJson(x)));

String pausedSalesModelToJson(List<PausedSalesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PausedSalesModel {
  final String? id;
  final String? orderNumber;
  final int? itemsCount;
  final Customer? customer;
  final DateTime? orderDate;
  final String? amount;
  final OrderDetails? orderDetails;

  PausedSalesModel({
    this.id,
    this.orderNumber,
    this.itemsCount,
    this.customer,
    this.orderDate,
    this.amount,
    this.orderDetails,
  });

  factory PausedSalesModel.fromJson(Map<String, dynamic> json) =>
      PausedSalesModel(
        id: json["id"],
        orderNumber: json["order_number"],
        itemsCount: json["items_count"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        orderDate: json["order_date"] == null
            ? null
            : DateTime.parse(json["order_date"]),
        amount: json["amount"],
        orderDetails: json["order_details"] == null
            ? null
            : OrderDetails.fromJson(json["order_details"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_number": orderNumber,
        "items_count": itemsCount,
        "customer": customer?.toJson(),
        "order_date": orderDate?.toIso8601String(),
        "amount": amount,
        "order_details": orderDetails?.toJson(),
      };
}

class OrderDetails {
  final String? status;
  final Customer? customer;
  final List<LineItem>? lineItems;
  final String? salesType;
  final dynamic discountId;
  final List<dynamic>? paymentMethods;
  final String? id;
  final String? pausedSalesId;

  OrderDetails({
    this.status,
    this.customer,
    this.lineItems,
    this.salesType,
    this.discountId,
    this.paymentMethods,
    this.id,
    this.pausedSalesId,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
        status: json["status"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        lineItems: json["line_items"] == null
            ? []
            : List<LineItem>.from(
                json["line_items"]!.map((x) => LineItem.fromJson(x))),
        salesType: json["sales_type"],
        discountId: json["discount_id"],
        paymentMethods: json["payment_methods"] == null
            ? []
            : List<dynamic>.from(json["payment_methods"]!.map((x) => x)),
        id: json["id"],
        pausedSalesId: json["paused_sales_id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "customer": customer?.toJson(),
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "sales_type": salesType,
        "discount_id": discountId,
        "payment_methods": paymentMethods == null
            ? []
            : List<dynamic>.from(paymentMethods!.map((x) => x)),
        "id": id,
        "paused_sales_id": pausedSalesId,
      };
}

class LineItem {
  final String? sku;
  final String? name;
  final int? quantity;
  final String? productId;
  final dynamic discountId;
  final int? totalPrice;
  final dynamic retailPrice;
  final String? primaryMediaUrl;
  final String? unitRetailPrice;

  LineItem({
    this.sku,
    this.name,
    this.quantity,
    this.productId,
    this.discountId,
    this.totalPrice,
    this.retailPrice,
    this.primaryMediaUrl,
    this.unitRetailPrice,
  });

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
        sku: json["SKU"],
        name: json["name"],
        quantity: json["quantity"],
        productId: json["product_id"],
        discountId: json["discount_id"],
        totalPrice: json["total_price"],
        retailPrice: json["retail_price"],
        primaryMediaUrl: json["primary_media_url"],
        unitRetailPrice: json["unit_retail_price"],
      );

  Map<String, dynamic> toJson() => {
        "SKU": sku,
        "name": name,
        "quantity": quantity,
        "product_id": productId,
        "discount_id": discountId,
        "total_price": totalPrice,
        "retail_price": retailPrice,
        "primary_media_url": primaryMediaUrl,
        "unit_retail_price": unitRetailPrice,
      };
}
