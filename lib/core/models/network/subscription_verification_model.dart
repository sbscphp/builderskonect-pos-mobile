import 'dart:convert';

SubscriptionVerifcationModel subscriptionVerifcationModelFromJson(String str) =>
    SubscriptionVerifcationModel.fromJson(json.decode(str));

class SubscriptionVerifcationModel {
  final String? identifierNo;
  final String? action;
  final String? reference;
  final Metadata? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  SubscriptionVerifcationModel({
    this.identifierNo,
    this.action,
    this.reference,
    this.metadata,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory SubscriptionVerifcationModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionVerifcationModel(
        identifierNo: json["identifier_no"],
        action: json["action"],
        reference: json["reference"],
        metadata: json["metadata"] == null
            ? null
            : Metadata.fromJson(json["metadata"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );
}

class Metadata {
  final String? name;
  final String? email;
  final String? phone;
  final String? company;
  final String? provider;
  final bool? freeTrial;
  final String? callbackUrl;
  final String? priceItemId;

  Metadata({
    this.name,
    this.email,
    this.phone,
    this.company,
    this.provider,
    this.freeTrial,
    this.callbackUrl,
    this.priceItemId,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        company: json["company"],
        provider: json["provider"],
        freeTrial: json["free_trial"],
        callbackUrl: json["callback_url"],
        priceItemId: json["price_item_id"],
      );
}
