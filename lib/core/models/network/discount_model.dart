import 'dart:convert';

DiscountModel discountFromJson(String str) =>
    DiscountModel.fromJson(json.decode(str));

List<DiscountModel> discountListFromJson(String str) =>
    List.from(json.decode(str)).map((e) => DiscountModel.fromJson(e)).toList();

class DiscountModel {
  final int? id;
  final String? name;
  final String? code;
  final String? category;
  final String? type;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? percent;
  final dynamic amount;
  final dynamic redemption;
  final String? status;

  DiscountModel({
    this.id,
    this.name,
    this.code,
    this.category,
    this.type,
    this.startDate,
    this.endDate,
    this.percent,
    this.amount,
    this.redemption,
    this.status,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) => DiscountModel(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        category: json["category"],
        type: json["type"],
        startDate:
            json["start_date"] != null ? DateTime.parse(json["start_date"]) : null,
        endDate:
            json["end_date"] != null ? DateTime.parse(json["end_date"]) : null,
        percent: json["percent"],
        amount: json["amount"],
        redemption: json["redemption"],
        status: json["status"],
      );
}