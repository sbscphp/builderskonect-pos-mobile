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
  final dynamic store;
  final dynamic storeId;
  final String? staffId;
  final dynamic lastActive;
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
        store: json["store"],
        storeId: json["store_id"],
        staffId: json["staffID"],
        lastActive: json["last_active"],
        merchantAccount: json["merchant_account"] == null
            ? []
            : List<MerchantAccount>.from(json["merchant_account"]!
                .map((x) => MerchantAccount.fromJson(x))),
        permissions: json["permissions"] == null
            ? []
            : List<dynamic>.from(json["permissions"]!.map((x) => x)),
      );
}

// class MerchantAccount {
//   final String? id;
//   final String? name;

//   MerchantAccount({
//     this.id,
//     this.name,
//   });

//   factory MerchantAccount.fromJson(Map<String, dynamic> json) =>
//       MerchantAccount(
//         id: json["id"],
//         name: json["name"],
//       );
// }
