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
  final String? identifierNo;
  final String? name;
  final String? email;
  final String? phone;
  final String? avatar;
  final dynamic provider;
  final dynamic providerId;
  final String? officerID;
  final String? location;
  final String? status;
  final String? activityStatus;
  final dynamic lastActive;
  final String? isActive;
  final String? dateJoined;
  final dynamic deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    this.identifierNo,
    this.name,
    this.email,
    this.phone,
    this.avatar,
    this.provider,
    this.providerId,
    this.officerID,
    this.location,
    this.status,
    this.activityStatus,
    this.lastActive,
    this.isActive,
    this.dateJoined,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        identifierNo: json["identifier_no"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        avatar: json["avatar"],
        provider: json["provider"],
        providerId: json["provider_id"],
        officerID: json["officer_id"],
        location: json["location"],
        status: json["status"],
        activityStatus: json["activity_status"],
        lastActive: json["last_active"],
        isActive: json["is_active"],
        dateJoined: json["date_joined"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "identifier_no": identifierNo,
        "name": name,
        "email": email,
        "phone": phone,
        "avatar": avatar,
        "provider": provider,
        "provider_id": providerId,
        "officer_id": officerID,
        "location": location,
        "status": status,
        "activity_status": activityStatus,
        "last_active": lastActive,
        "is_active": isActive,
        "date_joined": dateJoined,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
