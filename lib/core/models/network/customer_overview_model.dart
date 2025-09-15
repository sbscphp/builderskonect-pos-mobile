import 'dart:convert';

List<CustomerData> customerDataListFromJson(String str) =>
    List<CustomerData>.from(
        json.decode(str).map((x) => CustomerData.fromJson(x)));

CustomerData customerDataFromJson(String str) =>
    CustomerData.fromJson(json.decode(str));

class CustomerData {
  final String? id;
  final String? customerId;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? channel;
  final String? source;
  final dynamic shippingInformation;
  final dynamic billingInformation;
  final DateTime? dateJoined;

  CustomerData({
    this.id,
    this.customerId,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.channel,
    this.source,
    this.shippingInformation,
    this.billingInformation,
    this.dateJoined,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) => CustomerData(
        id: json["id"],
        customerId: json["customerID"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
        channel: json["channel"],
        source: json["source"],
        shippingInformation: json["shipping_information"],
        billingInformation: json["billing_information"],
        dateJoined: json["date_joined"] == null
            ? null
            : DateTime.parse(json["date_joined"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customerID": customerId,
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
        "channel": channel,
        "source": source,
        "shipping_information": shippingInformation,
        "billing_information": billingInformation,
        "date_joined": dateJoined?.toIso8601String(),
      };
}

CustomerStats customerStatsFromJson(String str) =>
    CustomerStats.fromJson(json.decode(str));

class CustomerStats {
  final int? total;
  final int? online;
  final int? offline;

  CustomerStats({
    this.total,
    this.online,
    this.offline,
  });

  factory CustomerStats.fromJson(Map<String, dynamic> json) => CustomerStats(
        total: json["total"],
        online: json["online"],
        offline: json["offline"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "online": online,
        "offline": offline,
      };
}
