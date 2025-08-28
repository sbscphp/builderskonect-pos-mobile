import 'dart:convert';

List<PaymentMethodsModel> paymentMethodsModelFromJson(String str) =>
    List<PaymentMethodsModel>.from(
        json.decode(str).map((x) => PaymentMethodsModel.fromJson(x)));

String paymentMethodsModelToJson(List<PaymentMethodsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentMethodsModel {
  final String? id;
  final String? name;
  final String? slug;
  final bool? isBalance;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PaymentMethodsModel({
    this.id,
    this.name,
    this.slug,
    this.isBalance,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentMethodsModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodsModel(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        isBalance: json["is_balance"],
        isActive: json["is_active"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "is_balance": isBalance,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaymentMethodsModel &&
        other.id == id &&
        other.name == name &&
        other.slug == slug &&
        other.isBalance == isBalance &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        slug.hashCode ^
        isBalance.hashCode ^
        isActive.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
