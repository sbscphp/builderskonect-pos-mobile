import 'dart:convert';

SalesAnalysisStat salesAnalysisStatFromJson(String str) =>
    SalesAnalysisStat.fromJson(json.decode(str));

String salesAnalysisStatToJson(SalesAnalysisStat data) =>
    json.encode(data.toJson());

class SalesAnalysisStat {
  final Orders? orders;
  final ItemsSold? orderValue;
  final ItemsSold? itemsSold;
  final Orders? returnsRate;

  SalesAnalysisStat({
    this.orders,
    this.orderValue,
    this.itemsSold,
    this.returnsRate,
  });

  factory SalesAnalysisStat.fromJson(Map<String, dynamic> json) =>
      SalesAnalysisStat(
        orders: json["orders"] == null ? null : Orders.fromJson(json["orders"]),
        orderValue: json["order_value"] == null
            ? null
            : ItemsSold.fromJson(json["order_value"]),
        itemsSold: json["items_sold"] == null
            ? null
            : ItemsSold.fromJson(json["items_sold"]),
        returnsRate: json["returns_rate"] == null
            ? null
            : Orders.fromJson(json["returns_rate"]),
      );

  Map<String, dynamic> toJson() => {
        "orders": orders?.toJson(),
        "order_value": orderValue?.toJson(),
        "items_sold": itemsSold?.toJson(),
        "returns_rate": returnsRate?.toJson(),
      };
}

class ItemsSold {
  final String? total;
  final String? shift;

  ItemsSold({
    this.total,
    this.shift,
  });

  factory ItemsSold.fromJson(Map<String, dynamic> json) => ItemsSold(
        total: json["total"],
        shift: json["shift"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "shift": shift,
      };
}

class Orders {
  final int? total;
  final String? shift;

  Orders({
    this.total,
    this.shift,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        total: json["total"],
        shift: json["shift"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "shift": shift,
      };
}
