import 'dart:convert';

import 'package:builders_konnect/core/models/network/auth_user_model.dart';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserProfileModel {
  final String? id;
  final String? avatar;
  final String? name;
  final String? email;
  final String? phone;
  final String? assignedRoles;
  final List<Role>? roles;
  final String? currentStoreId;
  final String? status;
  final List<Store>? store;
  final String? staffId;
  final DateTime? lastActive;
  final List<MerchantAccount>? merchantAccount;
  final List<String>? permissions;

  UserProfileModel({
    this.id,
    this.avatar,
    this.name,
    this.email,
    this.phone,
    this.assignedRoles,
    this.roles,
    this.currentStoreId,
    this.status,
    this.store,
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
        assignedRoles: json["assigned_roles"],
        roles: json["roles"] == null
            ? []
            : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
        currentStoreId: json["current_store_id"],
        status: json["status"],
        store: json["store"] == null
            ? []
            : List<Store>.from(json["store"]!.map((x) => Store.fromJson(x))),
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
            : List<String>.from(json["permissions"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "avatar": avatar,
        "name": name,
        "email": email,
        "phone": phone,
        "assigned_roles": assignedRoles,
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
        "current_store_id": currentStoreId,
        "status": status,
        "store": store == null
            ? []
            : List<dynamic>.from(store!.map((x) => x.toJson())),
        "staffID": staffId,
        "last_active": lastActive?.toIso8601String(),
        "merchant_account": merchantAccount == null
            ? []
            : List<dynamic>.from(merchantAccount!.map((x) => x.toJson())),
        "permissions": permissions == null
            ? []
            : List<dynamic>.from(permissions!.map((x) => x)),
      };
}

class Role {
  final int? id;
  final String? name;

  Role({
    this.id,
    this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Store {
  final String? id;
  final String? name;
  final bool? current;

  Store({
    this.id,
    this.name,
    this.current,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json["id"],
        name: json["name"],
        current: json["current"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "current": current,
      };
}
