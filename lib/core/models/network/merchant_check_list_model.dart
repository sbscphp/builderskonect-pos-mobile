import 'dart:convert';

MerchantCheckListModel merchantCheckListModelFromJson(String str) =>
    MerchantCheckListModel.fromJson(json.decode(str));

class MerchantCheckListModel {
  final bool? hasStore;
  final bool? hasRole;
  final bool? hasStaff;
  final bool? hasProducts;
  final bool? hasSales;

  MerchantCheckListModel({
    this.hasStore,
    this.hasRole,
    this.hasStaff,
    this.hasProducts,
    this.hasSales,
  });

  factory MerchantCheckListModel.fromJson(Map<String, dynamic> json) =>
      MerchantCheckListModel(
        hasStore: json["has_store"],
        hasRole: json["has_role"],
        hasStaff: json["has_staff"],
        hasProducts: json["has_products"],
        hasSales: json["has_sales"],
      );
}
