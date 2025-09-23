import 'dart:convert';

import 'package:builders_konnect/core/models/models.dart';

SalesOrdersModel salesOrdersModelFromJson(String str) =>
    SalesOrdersModel.fromJson(json.decode(str));

String salesOrdersModelToJson(SalesOrdersModel data) =>
    json.encode(data.toJson());

List<SalesOrdersModel> salesOrderDataListFromJson(String str) =>
    List<SalesOrdersModel>.from(
        json.decode(str).map((x) => SalesOrdersModel.fromJson(x)));

class SalesOrdersModel {
  final String? id;
  final String? orderNumber;
  final String? receiptNo;
  final int? itemsCount;
  final Customer? customer;
  final DateTime? date;
  final String? amount;
  final String? paymentStatus;
  final String? status;
  final String? salesType;
  final List<SalesDetailsPaymentMethod>? paymentMethods;
  final String? billingAddress;
  final String? shippingAddress;
  final List<SaleDetailsLineItem>? lineItems;
  final String? subtotal;
  final DiscountBreakdown? discountBreakdown;
  final Fees? fees;

  SalesOrdersModel({
    this.id,
    this.orderNumber,
    this.receiptNo,
    this.itemsCount,
    this.customer,
    this.date,
    this.amount,
    this.paymentStatus,
    this.status,
    this.salesType,
    this.paymentMethods,
    this.billingAddress,
    this.shippingAddress,
    this.lineItems,
    this.subtotal,
    this.discountBreakdown,
    this.fees,
  });

  factory SalesOrdersModel.fromJson(Map<String, dynamic> json) =>
      SalesOrdersModel(
        id: json["id"],
        orderNumber: json["order_number"],
        receiptNo: json["receipt_no"],
        itemsCount: json["items_count"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        amount: json["amount"],
        paymentStatus: json["payment_status"],
        status: json["status"],
        salesType: json["sales_type"],
        paymentMethods: json["payment_methods"] == null
            ? []
            : List<SalesDetailsPaymentMethod>.from(json["payment_methods"]!
                .map((x) => SalesDetailsPaymentMethod.fromJson(x))),
        billingAddress: json["billing_address"],
        shippingAddress: json["shipping_address"],
        lineItems: json["line_items"] == null
            ? []
            : List<SaleDetailsLineItem>.from(json["line_items"]!
                .map((x) => SaleDetailsLineItem.fromJson(x))),
        subtotal: json["subtotal"],
        discountBreakdown: json["discount_breakdown"] == null
            ? null
            : DiscountBreakdown.fromJson(json["discount_breakdown"]),
        fees: json["fees"] == null ? null : Fees.fromJson(json["fees"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_number": orderNumber,
        "receipt_no": receiptNo,
        "items_count": itemsCount,
        "customer": customer?.toJson(),
        "date": date?.toIso8601String(),
        "amount": amount,
        "payment_status": paymentStatus,
        "status": status,
        "sales_type": salesType,
        "payment_methods": paymentMethods == null
            ? []
            : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
        "billing_address": billingAddress,
        "shipping_address": shippingAddress,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "subtotal": subtotal,
        "discount_breakdown": discountBreakdown?.toJson(),
        "fees": fees?.toJson(),
      };
}

class DiscountBreakdown {
  final String? totalProductDiscounts;
  final String? orderDiscount;

  DiscountBreakdown({
    this.totalProductDiscounts,
    this.orderDiscount,
  });

  factory DiscountBreakdown.fromJson(Map<String, dynamic> json) =>
      DiscountBreakdown(
        totalProductDiscounts: json["total_product_discounts"],
        orderDiscount: json["order_discount"],
      );

  Map<String, dynamic> toJson() => {
        "total_product_discounts": totalProductDiscounts,
        "order_discount": orderDiscount,
      };
}

class SaleDetailsLineItem {
  final String? lineItemId;
  final String? product;
  final String? productMediaUrl;
  final String? productSku;
  final String? productType;
  final int? quantity;
  final String? unitCost;
  final String? discountedAmount;
  final String? totalCost;

  SaleDetailsLineItem({
    this.lineItemId,
    this.product,
    this.productMediaUrl,
    this.productSku,
    this.productType,
    this.quantity,
    this.unitCost,
    this.discountedAmount,
    this.totalCost,
  });

  factory SaleDetailsLineItem.fromJson(Map<String, dynamic> json) =>
      SaleDetailsLineItem(
        lineItemId: json["line_item_id"],
        product: json["product"],
        productMediaUrl: json["product_media_url"],
        productSku: json["product_sku"],
        productType: json["product_type"],
        quantity: json["quantity"],
        unitCost: json["unit_cost"],
        discountedAmount: json["discounted_amount"],
        totalCost: json["total_cost"],
      );

  Map<String, dynamic> toJson() => {
        "line_item_id": lineItemId,
        "product": product,
        "product_media_url": productMediaUrl,
        "product_sku": productSku,
        "product_type": productType,
        "quantity": quantity,
        "unit_cost": unitCost,
        "discounted_amount": discountedAmount,
        "total_cost": totalCost,
      };
}

class SalesDetailsPaymentMethod {
  final String? method;
  final String? amount;

  SalesDetailsPaymentMethod({
    this.method,
    this.amount,
  });

  factory SalesDetailsPaymentMethod.fromJson(Map<String, dynamic> json) =>
      SalesDetailsPaymentMethod(
        method: json["method"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "method": method,
        "amount": amount,
      };
}
