import 'package:builders_konnect/core/core.dart';

TransferProductModel transferProductFromJson(String str) =>
    TransferProductModel.fromJson(json.decode(str));

List<TransferProductModel> transferProductListFromJson(String str) =>
    List.from(json.decode(str))
        .map((e) => TransferProductModel.fromJson(e))
        .toList();

List<LineItemProduct> lineitemProductListFromJson(String str) =>
    List.from(json.decode(str))
        .map((e) => LineItemProduct.fromJson(e))
        .toList();

class TransferProductModel {
  final String? id;
  final String? reference;
  final TransferData? source;
  final TransferData? destination;
  final String? status;
  final DateTime? dateInitiated;
  final int? productCount;
  final dynamic quantity;
  final String? direction;
  final String? viewiingAs;
  final String? initiatedBy;
  final dynamic updatedBy;
  final DateTime? decisionDate;
  final dynamic reason;
  final dynamic approvedProductsCount;
  final dynamic declinedProductsCount;
  final PaginatedData? lineItems;

  TransferProductModel(
      {this.id,
      this.reference,
      this.source,
      this.destination,
      this.status,
      this.dateInitiated,
      this.productCount,
      this.quantity,
      this.direction,
      this.viewiingAs,
      this.initiatedBy,
      this.updatedBy,
      this.decisionDate,
      this.reason,
      this.approvedProductsCount,
      this.declinedProductsCount,
      this.lineItems});

  factory TransferProductModel.fromJson(Map<String, dynamic> json) =>
      TransferProductModel(
        id: json['id'],
        reference: json['reference'],
        source: json['source'] != null
            ? TransferData.fromJson(json['source'])
            : null,
        destination: json['destination'] != null
            ? TransferData.fromJson(json['destination'])
            : null,
        status: json['status'],
        dateInitiated: json['date_initiated'] != null
            ? DateTime.parse(json['date_initiated'])
            : null,
        productCount: json['product_count'],
        quantity: json['quantity'],
        direction: json['direction'],
        viewiingAs: json['viewing_as'],
        initiatedBy: json['initiated_by'],
        updatedBy: json['updated_by'],
        decisionDate: json['decision_date'] != null
            ? DateTime.parse(json['decision_date'])
            : null,
        reason: json['reason'],
        approvedProductsCount: json['approved_products_count'],
        declinedProductsCount: json['declined_products_count'],
        lineItems: json['line_items'] != null
            ? PaginatedData.fromJson(json['line_items'])
            : null,
      );
}

class TransferData {
  final String? identifierNo;
  final String? name;

  TransferData({this.identifierNo, this.name});
  factory TransferData.fromJson(Map<String, dynamic> json) =>
      TransferData(identifierNo: json["identifier_no"], name: json["name"]);
}

class LineItemProduct {
  final String? id;
  final String? name;
  final String? sku;
  final int? quantity;
  final String? primaryMediaUrl;
  final String? status;
  final String? reason;
  final bool? canDecide;
  final bool? canReceive;

  LineItemProduct(
      {this.id,
      this.name,
      this.sku,
      this.quantity,
      this.primaryMediaUrl,
      this.status,
      this.reason,
      this.canDecide,
      this.canReceive});

  factory LineItemProduct.fromJson(Map<String, dynamic> json) =>
      LineItemProduct(
          id: json['id'],
          name: json['name'],
          sku: json['SKU'],
          quantity: json['quantity'],
          primaryMediaUrl: json['primary_media_url'],
          status: json['status'],
          reason: json['reason'],
          canDecide: json['can_decide'],
          canReceive: json['can_receive']);
}
