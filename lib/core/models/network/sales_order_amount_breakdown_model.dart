import 'dart:convert';

SalesOrderAmountBreakdownModel salesOrderAmountBreakdownModelFromJson(
        String str) =>
    SalesOrderAmountBreakdownModel.fromJson(json.decode(str));

String salesOrderAmountBreakdownModelToJson(
        SalesOrderAmountBreakdownModel data) =>
    json.encode(data.toJson());

class SalesOrderAmountBreakdownModel {
  final int? itemsCount;
  final int? totalItemQuantity;
  final num? subtotal;
  final List<dynamic>? discountBreakdown;
  final num? totalProductDiscount;
  final num? salesOrderDiscount;
  final num? totalDiscount;
  final Fees? fees;
  final double? total;

  SalesOrderAmountBreakdownModel({
    this.itemsCount,
    this.totalItemQuantity,
    this.subtotal,
    this.discountBreakdown,
    this.totalProductDiscount,
    this.salesOrderDiscount,
    this.totalDiscount,
    this.fees,
    this.total,
  });

  factory SalesOrderAmountBreakdownModel.fromJson(Map<String, dynamic> json) =>
      SalesOrderAmountBreakdownModel(
        itemsCount: json["items_count"],
        totalItemQuantity: json["total_item_quantity"],
        subtotal: json["subtotal"],
        discountBreakdown: json["discount_breakdown"] == null
            ? []
            : List<dynamic>.from(json["discount_breakdown"]!.map((x) => x)),
        totalProductDiscount: json["total_product_discount"],
        salesOrderDiscount: json["sales_order_discount"],
        totalDiscount: json["total_discount"],
        fees: json["fees"] == null ? null : Fees.fromJson(json["fees"]),
        total: json["total"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "items_count": itemsCount,
        "total_item_quantity": totalItemQuantity,
        "subtotal": subtotal,
        "discount_breakdown": discountBreakdown == null
            ? []
            : List<dynamic>.from(discountBreakdown!.map((x) => x)),
        "total_product_discount": totalProductDiscount,
        "sales_order_discount": salesOrderDiscount,
        "total_discount": totalDiscount,
        "fees": fees?.toJson(),
        "total": total,
      };
}

class Fees {
  final String? tax;
  final double? taxAmount;
  final int? serviceFee;
  final num? deliveryFee;

  Fees({
    this.tax,
    this.taxAmount,
    this.serviceFee,
    this.deliveryFee,
  });

  factory Fees.fromJson(Map<String, dynamic> json) => Fees(
        tax: json["tax"],
        taxAmount: json["tax_amount"]?.toDouble(),
        serviceFee: json["service_fee"],
        deliveryFee: json["delivery_fee"],
      );

  Map<String, dynamic> toJson() => {
        "tax": tax,
        "tax_amount": taxAmount,
        "service_fee": serviceFee,
        "delivery_fee": deliveryFee,
      };
}
