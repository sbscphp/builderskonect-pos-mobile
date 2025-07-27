import 'dart:convert';

AuthUserModel authUserModelFromJson(String str) =>
    AuthUserModel.fromJson(json.decode(str));

String authUserModelToJson(AuthUserModel data) => json.encode(data.toJson());

class AuthUserModel {
  final User? user;
  final String? accessToken;

  AuthUserModel({
    this.user,
    this.accessToken,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) => AuthUserModel(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        accessToken: json["accessToken"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "accessToken": accessToken,
      };
}

class User {
  final String? id;
  final dynamic avatar;
  final String? name;
  final String? email;
  final String? phone;
  final String? assignedRoles;
  final List<dynamic>? roles;
  final String? currentStoreId;
  final String? status;
  final List<dynamic>? store;
  final String? staffId;
  final DateTime? lastActive;
  final List<MerchantAccount>? merchantAccount;
  final List<dynamic>? permissions;

  User({
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

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        avatar: json["avatar"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        assignedRoles: json["assigned_roles"],
        roles: json["roles"] == null
            ? []
            : List<dynamic>.from(json["roles"]!.map((x) => x)),
        currentStoreId: json["current_store_id"],
        status: json["status"],
        store: json["store"] == null
            ? []
            : List<dynamic>.from(json["store"]!.map((x) => x)),
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "avatar": avatar,
        "name": name,
        "email": email,
        "phone": phone,
        "assigned_roles": assignedRoles,
        "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x)),
        "current_store_id": currentStoreId,
        "status": status,
        "store": store == null ? [] : List<dynamic>.from(store!.map((x) => x)),
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

class MerchantAccount {
  final String? id;
  final String? name;

  MerchantAccount({
    this.id,
    this.name,
  });

  factory MerchantAccount.fromJson(Map<String, dynamic> json) =>
      MerchantAccount(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
