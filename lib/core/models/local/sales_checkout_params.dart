import 'dart:convert';

SalesCheckoutParams salesCheckoutParamsFromJson(String str) =>
    SalesCheckoutParams.fromJson(json.decode(str));

String salesCheckoutParamsToJson(SalesCheckoutParams data) =>
    json.encode(data.toJson());

class SalesCheckoutParams {
  final List<Order>? orders;

  SalesCheckoutParams({
    this.orders,
  });

  factory SalesCheckoutParams.fromJson(Map<String, dynamic> json) =>
      SalesCheckoutParams(
        orders: json["orders"] == null
            ? []
            : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orders": orders == null
            ? []
            : List<dynamic>.from(orders!.map((x) => x.toJson())),
      };
}

class Order {
  final CustomerCred? customer;
  final String? status;
  final String? discountId;
  final String? salesType;
  final List<LineItemParams>? lineItems;
  final List<SalesPaymentMethod>? paymentMethods;
  final String? pausedSalesId;

  Order({
    this.customer,
    this.status,
    this.discountId,
    this.salesType,
    this.lineItems,
    this.paymentMethods,
    this.pausedSalesId,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        customer: json["customer"] == null
            ? null
            : CustomerCred.fromJson(json["customer"]),
        status: json["status"],
        discountId: json["discount_id"],
        salesType: json["sales_type"],
        lineItems: json["line_items"] == null
            ? []
            : List<LineItemParams>.from(
                json["line_items"]!.map((x) => LineItemParams.fromJson(x))),
        paymentMethods: json["payment_methods"] == null
            ? []
            : List<SalesPaymentMethod>.from(json["payment_methods"]!
                .map((x) => SalesPaymentMethod.fromJson(x))),
        pausedSalesId: json["paused_sales_id"],
      );

  Map<String, dynamic> toJson() => {
        "customer": customer?.toJson(),
        "status": status,
        "discount_id": discountId,
        "sales_type": salesType,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "payment_methods": paymentMethods == null
            ? []
            : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
        "paused_sales_id": pausedSalesId,
      };
}

class CustomerCred {
  // if id is available, you can ignore the rest of the customer payload
  final String? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? referralSource;
  final String? openedVia;

  CustomerCred({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.referralSource,
    this.openedVia,
  });

  factory CustomerCred.fromJson(Map<String, dynamic> json) => CustomerCred(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        referralSource: json["referral_source"],
        openedVia: json["opened_via"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "referral_source": referralSource,
        "opened_via": openedVia,
      };
}

class LineItemParams {
  final String? productId;
  final int? quantity;
  final String? discountId;

  LineItemParams({
    this.productId,
    this.quantity,
    this.discountId,
  });

  factory LineItemParams.fromJson(Map<String, dynamic> json) => LineItemParams(
        productId: json["product_id"],
        quantity: json["quantity"],
        discountId: json["discount_id"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "quantity": quantity,
        "discount_id": discountId,
      };
}

class SalesPaymentMethod {
  final String? id;
  final double? amount;

  SalesPaymentMethod({
    this.id,
    this.amount,
  });

  factory SalesPaymentMethod.fromJson(Map<String, dynamic> json) =>
      SalesPaymentMethod(
        id: json["id"],
        amount: json["amount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
      };
}
