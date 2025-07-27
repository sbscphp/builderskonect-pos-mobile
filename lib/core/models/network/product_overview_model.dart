import 'dart:convert';

ProductOverviewModel productOverviewModelFromJson(String str) =>
    ProductOverviewModel.fromJson(json.decode(str));

class ProductOverviewModel {
  final String? productsCount;
  final String? productsValue;
  final String? sales;
  final List<TopCategory>? topCategories;

  ProductOverviewModel({
    this.productsCount,
    this.productsValue,
    this.sales,
    this.topCategories,
  });

  factory ProductOverviewModel.fromJson(Map<String, dynamic> json) =>
      ProductOverviewModel(
        productsCount: json["products_count"],
        productsValue: json["products_value"],
        sales: json["sales"],
        topCategories: json["top_categories"] == null
            ? []
            : List<TopCategory>.from(
                json["top_categories"]!.map((x) => TopCategory.fromJson(x))),
      );
}

class TopCategory {
  final String? id;
  final String? categoryName;
  final int? totalOrders;
  final String? totalQuantity;
  final String? totalRevenue;

  TopCategory({
    this.id,
    this.categoryName,
    this.totalOrders,
    this.totalQuantity,
    this.totalRevenue,
  });

  factory TopCategory.fromJson(Map<String, dynamic> json) => TopCategory(
        id: json["id"],
        categoryName: json["category_name"],
        totalOrders: json["total_orders"],
        totalQuantity: json["total_quantity"],
        totalRevenue: json["total_revenue"],
      );
}
