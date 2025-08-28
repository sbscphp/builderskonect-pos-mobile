import 'dart:convert';

StaffModel staffModelFromJson(String str) =>
    StaffModel.fromJson(json.decode(str));

List<StaffModel> staffModelListFromJson(String str) =>
    List.from(json.decode(str)).map((e) => StaffModel.fromJson(e)).toList();

class StaffModel {
  final String? id;
  final String? avatar;
  final String? name;
  final String? email;
  final String? phone;
  final dynamic assignedRoles;
  final List<dynamic>? roles;
  final String? currentStoreId;
  final String? status;
  final List<dynamic>? store;
  final String? staffId;
  final DateTime? lastActive;
  final List<dynamic>? merchantAccount;
  final List<String?>? permissions;

  StaffModel(
      {this.id,
      this.avatar,
      this.name,
      this.email,
      this.phone,
      this.roles,
      this.assignedRoles,
      this.currentStoreId,
      this.staffId,
      this.status,
      this.store,
      this.lastActive,
      this.merchantAccount,
      this.permissions});

  factory StaffModel.fromJson(Map<String, dynamic> json) => StaffModel(
        id: json['id'],
        avatar: json['avatar'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        assignedRoles: json['assigned_roles'],
        roles: json['roles']  != null ? List<dynamic>.from(json["roles"]) : null,
        currentStoreId: json['current_store_id'],
        status: json['status'],
        store: json['store'] != null ? List<dynamic>.from(json["store"]) : null,
        staffId: json['staffID'],
        lastActive: json['last_active'] != null
            ? DateTime.parse(json["last_active"])
            : null,
        merchantAccount: json['merchant_account'],
        permissions: json['permissions'] != null ? List<String?>.from(json["permissions"]) : null,
      );
}
