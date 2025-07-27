import 'dart:convert';

StatModel statModelFromJson(String str) => StatModel.fromJson(json.decode(str));

class StatModel {
  final String? totalProducts;
  final String? revenueGenerated;
  final String? totalSalesOrders;
  final int? totalCustomers;

  StatModel({
    this.totalProducts,
    this.revenueGenerated,
    this.totalSalesOrders,
    this.totalCustomers,
  });

  factory StatModel.fromJson(Map<String, dynamic> json) => StatModel(
        totalProducts: json["total_products"],
        revenueGenerated: json["revenue_generated"],
        totalSalesOrders: json["total_sales_orders"],
        totalCustomers: json["total_customers"],
      );
}
