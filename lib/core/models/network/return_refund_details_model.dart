import 'dart:convert';

ReturnRefurnDetailsModel returnRefurnDetailsModelFromJson(String str) =>
    ReturnRefurnDetailsModel.fromJson(json.decode(str));

String returnRefurnDetailsModelToJson(ReturnRefurnDetailsModel data) =>
    json.encode(data.toJson());

class ReturnRefurnDetailsModel {
  final String? id;
  final String? productName;
  final String? productSku;
  final DateTime? dateReturned;
  final String? orderId;
  final String? totalAmountRefunded;
  final String? customerName;
  final String? customerEmail;
  final String? status;
  final String? locationName;
  final dynamic discount;
  final List<PaymentMethod>? paymentMethod;
  final DateTime? dateBought;
  final String? cashier;
  final String? reason;
  final String? customerPhone;
  final int? ordersCount;
  final String? customerId;
  final String? productId;
  final List<String>? media;

  ReturnRefurnDetailsModel({
    this.id,
    this.productName,
    this.productSku,
    this.dateReturned,
    this.orderId,
    this.totalAmountRefunded,
    this.customerName,
    this.customerEmail,
    this.status,
    this.locationName,
    this.discount,
    this.paymentMethod,
    this.dateBought,
    this.cashier,
    this.reason,
    this.customerPhone,
    this.ordersCount,
    this.customerId,
    this.productId,
    this.media,
  });

  factory ReturnRefurnDetailsModel.fromJson(Map<String, dynamic> json) =>
      ReturnRefurnDetailsModel(
        id: json["id"],
        productName: json["product_name"],
        productSku: json["product_sku"],
        dateReturned: json["date_returned"] == null
            ? null
            : DateTime.parse(json["date_returned"]),
        orderId: json["orderID"],
        totalAmountRefunded: json["total_amount_refunded"],
        customerName: json["customer_name"],
        customerEmail: json["customer_email"],
        status: json["status"],
        locationName: json["location_name"],
        discount: json["discount"],
        paymentMethod: json["payment_method"] == null
            ? []
            : List<PaymentMethod>.from(
                json["payment_method"]!.map((x) => PaymentMethod.fromJson(x))),
        dateBought: json["date_bought"] == null
            ? null
            : DateTime.parse(json["date_bought"]),
        cashier: json["cashier"],
        reason: json["reason"],
        customerPhone: json["customer_phone"],
        ordersCount: json["orders_count"],
        customerId: json["customer_id"],
        productId: json["product_id"],
        media: json["media"] == null
            ? []
            : List<String>.from(json["media"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_name": productName,
        "product_sku": productSku,
        "date_returned": dateReturned?.toIso8601String(),
        "orderID": orderId,
        "total_amount_refunded": totalAmountRefunded,
        "customer_name": customerName,
        "customer_email": customerEmail,
        "status": status,
        "location_name": locationName,
        "discount": discount,
        "payment_method": paymentMethod == null
            ? []
            : List<dynamic>.from(paymentMethod!.map((x) => x.toJson())),
        "date_bought": dateBought?.toIso8601String(),
        "cashier": cashier,
        "reason": reason,
        "customer_phone": customerPhone,
        "orders_count": ordersCount,
        "customer_id": customerId,
        "product_id": productId,
        "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x)),
      };
}

class PaymentMethod {
  final String? name;
  final String? amount;

  PaymentMethod({
    this.name,
    this.amount,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        name: json["name"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "amount": amount,
      };
}
