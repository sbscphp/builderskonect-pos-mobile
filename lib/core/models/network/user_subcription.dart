import 'dart:convert';

List<UserSubcription> userSubcriptionFromJson(String str) =>
    List<UserSubcription>.from(
        json.decode(str).map((x) => UserSubcription.fromJson(x)));

class UserSubcription {
  final String? id;
  final String? merchant;
  final String? merchantCode;
  final DateTime? paymentDate;
  final String? paymentReference;
  final String? amountPaid;
  final String? planName;
  final String? interval;
  final String? paymentMethod;
  final String? paymentChannel;
  final String? status;
  final String? planAmount;
  final String? paymentStatus;
  final String? discount;
  final String? vat;
  final String? description;
  final String? priceItemId;
  final DateTime? subscribedAt;
  final DateTime? nextPaymentDate;
  final DateTime? endDate;
  final List<Feature>? features;

  UserSubcription({
    this.id,
    this.merchant,
    this.merchantCode,
    this.paymentDate,
    this.paymentReference,
    this.amountPaid,
    this.planName,
    this.interval,
    this.paymentMethod,
    this.paymentChannel,
    this.status,
    this.planAmount,
    this.paymentStatus,
    this.discount,
    this.vat,
    this.description,
    this.priceItemId,
    this.subscribedAt,
    this.nextPaymentDate,
    this.endDate,
    this.features,
  });

  factory UserSubcription.fromJson(Map<String, dynamic> json) =>
      UserSubcription(
        id: json["id"],
        merchant: json["merchant"],
        merchantCode: json["merchant_code"],
        paymentDate: json["payment_date"] == null
            ? null
            : DateTime.parse(json["payment_date"]),
        paymentReference: json["payment_reference"],
        amountPaid: json["amount_paid"],
        planName: json["plan_name"],
        interval: json["interval"],
        paymentMethod: json["payment_method"],
        paymentChannel: json["payment_channel"],
        status: json["status"],
        planAmount: json["plan_amount"],
        paymentStatus: json["payment_status"],
        discount: json["discount"],
        vat: json["vat"],
        description: json["description"],
        priceItemId: json["price_item_id"],
        subscribedAt: json["subscribed_at"] == null
            ? null
            : DateTime.parse(json["subscribed_at"]),
        nextPaymentDate: json["next_payment_date"] == null
            ? null
            : DateTime.parse(json["next_payment_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        features: json["features"] == null
            ? []
            : List<Feature>.from(
                json["features"]!.map((x) => Feature.fromJson(x))),
      );
}

class Feature {
  final String? id;
  final String? name;

  Feature({
    this.id,
    this.name,
  });

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        name: json["name"],
      );
}
