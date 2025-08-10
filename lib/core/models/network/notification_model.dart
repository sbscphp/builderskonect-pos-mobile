import 'dart:convert';

List<NotificationModel> notificationModelFromJson(String str) =>
    List<NotificationModel>.from(
        json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationModelToJson(List<NotificationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel {
  final String? id;
  final String? subject;
  final String? message;
  final DateTime? createdAt;
  final dynamic readAt;
  final String? dateString;
  final NotificationMetadata? metadata;

  NotificationModel({
    this.id,
    this.subject,
    this.message,
    this.createdAt,
    this.readAt,
    this.dateString,
    this.metadata,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        subject: json["subject"],
        message: json["message"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        readAt: json["read_at"],
        dateString: json["date_string"],
        metadata: json["metadata"] == null
            ? null
            : NotificationMetadata.fromJson(json["metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subject": subject,
        "message": message,
        "created_at": createdAt?.toIso8601String(),
        "read_at": readAt,
        "date_string": dateString,
        "metadata": metadata?.toJson(),
      };
}

class NotificationMetadata {
  final int? orderId;
  final String? orderNumber;
  final String? status;
  final String? trackingNumber;
  final DateTime? estimatedDelivery;
  final ShippingAddress? shippingAddress;
  final int? conversationId;
  final Sender? sender;
  final String? messageId;
  final String? orderReference;
  final String? messageType;
  final String? maintenanceId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? duration;
  final List<String>? affectedServices;
  final String? impactLevel;
  final Contact? contact;

  NotificationMetadata({
    this.orderId,
    this.orderNumber,
    this.status,
    this.trackingNumber,
    this.estimatedDelivery,
    this.shippingAddress,
    this.conversationId,
    this.sender,
    this.messageId,
    this.orderReference,
    this.messageType,
    this.maintenanceId,
    this.startDate,
    this.endDate,
    this.duration,
    this.affectedServices,
    this.impactLevel,
    this.contact,
  });

  factory NotificationMetadata.fromJson(Map<String, dynamic> json) =>
      NotificationMetadata(
        orderId: json["order_id"],
        orderNumber: json["order_number"],
        status: json["status"],
        trackingNumber: json["tracking_number"],
        estimatedDelivery: json["estimated_delivery"] == null
            ? null
            : DateTime.parse(json["estimated_delivery"]),
        shippingAddress: json["shipping_address"] == null
            ? null
            : ShippingAddress.fromJson(json["shipping_address"]),
        conversationId: json["conversation_id"],
        sender: json["sender"] == null ? null : Sender.fromJson(json["sender"]),
        messageId: json["message_id"],
        orderReference: json["order_reference"],
        messageType: json["message_type"],
        maintenanceId: json["maintenance_id"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        duration: json["duration"],
        affectedServices: json["affected_services"] == null
            ? []
            : List<String>.from(json["affected_services"]!.map((x) => x)),
        impactLevel: json["impact_level"],
        contact:
            json["contact"] == null ? null : Contact.fromJson(json["contact"]),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "order_number": orderNumber,
        "status": status,
        "tracking_number": trackingNumber,
        "estimated_delivery":
            "${estimatedDelivery!.year.toString().padLeft(4, '0')}-${estimatedDelivery!.month.toString().padLeft(2, '0')}-${estimatedDelivery!.day.toString().padLeft(2, '0')}",
        "shipping_address": shippingAddress?.toJson(),
        "conversation_id": conversationId,
        "sender": sender?.toJson(),
        "message_id": messageId,
        "order_reference": orderReference,
        "message_type": messageType,
        "maintenance_id": maintenanceId,
        "start_date":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "duration": duration,
        "affected_services": affectedServices == null
            ? []
            : List<dynamic>.from(affectedServices!.map((x) => x)),
        "impact_level": impactLevel,
        "contact": contact?.toJson(),
      };
}

class Contact {
  final String? name;
  final String? email;
  final String? phone;

  Contact({
    this.name,
    this.email,
    this.phone,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
      };
}

class Sender {
  final int? id;
  final String? name;
  final String? email;

  Sender({
    this.id,
    this.name,
    this.email,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        id: json["id"],
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
      };
}

class ShippingAddress {
  final String? street;
  final String? city;
  final String? state;
  final String? zip;

  ShippingAddress({
    this.street,
    this.city,
    this.state,
    this.zip,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      ShippingAddress(
        street: json["street"],
        city: json["city"],
        state: json["state"],
        zip: json["zip"],
      );

  Map<String, dynamic> toJson() => {
        "street": street,
        "city": city,
        "state": state,
        "zip": zip,
      };
}
