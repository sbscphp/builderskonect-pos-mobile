import 'dart:convert';

List<SubscriptionPlan> subscriptionPlanFromJson(String str) =>
    List<SubscriptionPlan>.from(
        json.decode(str).map((x) => SubscriptionPlan.fromJson(x)));

String subscriptionPlanToJson(List<SubscriptionPlan> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubscriptionPlan {
  final String? id;
  final String? name;
  final String? code;
  final String? description;
  final List<PlanFeature>? features;
  final List<PriceItem>? priceItems;

  SubscriptionPlan({
    this.id,
    this.name,
    this.code,
    this.description,
    this.features,
    this.priceItems,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlan(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        description: json["description"],
        features: json["features"] == null
            ? []
            : List<PlanFeature>.from(
                json["features"]!.map((x) => PlanFeature.fromJson(x))),
        priceItems: json["price_items"] == null
            ? []
            : List<PriceItem>.from(
                json["price_items"]!.map((x) => PriceItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "description": description,
        "features": features == null
            ? []
            : List<dynamic>.from(features!.map((x) => x.toJson())),
        "price_items": priceItems == null
            ? []
            : List<dynamic>.from(priceItems!.map((x) => x.toJson())),
      };
}

class PlanFeature {
  final String? id;
  final String? name;

  PlanFeature({
    this.id,
    this.name,
  });

  factory PlanFeature.fromJson(Map<String, dynamic> json) => PlanFeature(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class PriceItem {
  final String? id;
  final String? amount;
  final String? interval;
  final int? freeDays;
  final String? vat;
  final String? discount;

  PriceItem({
    this.id,
    this.amount,
    this.interval,
    this.freeDays,
    this.vat,
    this.discount,
  });

  factory PriceItem.fromJson(Map<String, dynamic> json) => PriceItem(
        id: json["id"],
        amount: json["amount"],
        interval: json["interval"],
        freeDays: json["free_days"],
        vat: json["vat"],
        discount: json["discount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "interval": interval,
        "free_days": freeDays,
        "vat": vat,
        "discount": discount,
      };
}
