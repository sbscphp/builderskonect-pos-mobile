import 'dart:convert';

List<TopSellingProduct> topSellingProductFromJson(String str) =>
    List<TopSellingProduct>.from(
        json.decode(str).map((x) => TopSellingProduct.fromJson(x)));

String topSellingProductToJson(List<TopSellingProduct> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TopSellingProduct {
  final String? name;
  final String? sku;
  final int? quantitySold;
  final String? primaryImageUrl;

  TopSellingProduct({
    this.name,
    this.sku,
    this.quantitySold,
    this.primaryImageUrl,
  });

  factory TopSellingProduct.fromJson(Map<String, dynamic> json) =>
      TopSellingProduct(
        name: json["name"],
        sku: json["sku"],
        quantitySold: json["quantity_sold"],
        primaryImageUrl: json["primary_image_url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "sku": sku,
        "quantity_sold": quantitySold,
        "primary_image_url": primaryImageUrl,
      };
}
