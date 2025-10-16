import 'dart:convert';

PlanBreakDownModel planBreakDownFromJson(String str) =>
    PlanBreakDownModel.fromJson(json.decode(str));

class PlanBreakDownModel {
  final String? planAmount;
  final int? vatAmount;
  final double? discountAmount;
  final double? amountDue;
  final Map<String, dynamic>? fees;

  PlanBreakDownModel({
    this.planAmount,
    this.vatAmount,
    this.discountAmount,
    this.amountDue,
    this.fees,
  });

  factory PlanBreakDownModel.fromJson(Map<String, dynamic> json) =>
      PlanBreakDownModel(
        planAmount: json["plan_amount"],
        vatAmount: json["vat_amount"],
        discountAmount: json["discount_amount"]?.toDouble(),
        amountDue: json["amount_due"]?.toDouble(),
        fees: json["fees"],
      );
}
