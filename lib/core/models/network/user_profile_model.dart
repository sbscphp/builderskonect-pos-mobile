import 'dart:convert';

import 'package:builders_konnect/core/models/network/auth_user_model.dart';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

class UserProfileModel {
  final String? id;
  final dynamic avatar;
  final String? name;
  final String? email;
  final String? phone;
  final dynamic role;
  final dynamic roleId;
  final String? status;
  final List<MerchantAccount>? store;
  final dynamic storeId;
  final String? staffId;
  final DateTime? lastActive;
  final List<MerchantAccount>? merchantAccount;
  final List<dynamic>? permissions;

  UserProfileModel({
    this.id,
    this.avatar,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.roleId,
    this.status,
    this.store,
    this.storeId,
    this.staffId,
    this.lastActive,
    this.merchantAccount,
    this.permissions,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        id: json["id"],
        avatar: json["avatar"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        role: json["role"],
        roleId: json["role_id"],
        status: json["status"],
        store: json["store"] == null
            ? []
            : List<MerchantAccount>.from(
                json["store"]!.map((x) => MerchantAccount.fromJson(x))),
        storeId: json["store_id"],
        staffId: json["staffID"],
        lastActive: json["last_active"] == null
            ? null
            : DateTime.parse(json["last_active"]),
        merchantAccount: json["merchant_account"] == null
            ? []
            : List<MerchantAccount>.from(json["merchant_account"]!
                .map((x) => MerchantAccount.fromJson(x))),
        permissions: json["permissions"] == null
            ? []
            : List<dynamic>.from(json["permissions"]!.map((x) => x)),
      );
}
