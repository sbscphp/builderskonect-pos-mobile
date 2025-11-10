import 'dart:convert';

import 'package:builders_konnect/core/models/network/city_model.dart';
import 'package:builders_konnect/core/models/network/state_model.dart';

VendorProfileModel profileModelFromJson(String str) =>
    VendorProfileModel.fromJson(json.decode(str));

class VendorProfileModel {
  final String? id;
  final String? logo;
  final String? status;
  final String? onboardingStatus;
  final Business? business;
  final Finance? finance;
  final Documents? documents;

  VendorProfileModel({
    this.id,
    this.logo,
    this.status,
    this.onboardingStatus,
    this.business,
    this.finance,
    this.documents,
  });

  factory VendorProfileModel.fromJson(Map<String, dynamic> json) =>
      VendorProfileModel(
        id: json["id"],
        logo: json["logo"],
        status: json["status"],
        onboardingStatus: json["onboarding_status"],
        business: json["business"] == null
            ? null
            : Business.fromJson(json["business"]),
        finance:
            json["finance"] == null ? null : Finance.fromJson(json["finance"]),
        documents: json["documents"] == null
            ? null
            : Documents.fromJson(json["documents"]),
      );
}

class Business {
  final String? name;
  final String? email;
  final String? category;
  final String? type;
  final String? phone;
  final String? vendorId;
  final String? address;
  final StateModel? state;
  final StateModel? country;
  final CityModel? city;

  Business({
    this.name,
    this.email,
    this.category,
    this.type,
    this.phone,
    this.vendorId,
    this.address,
    this.state,
    this.country,
    this.city,
  });

  factory Business.fromJson(Map<String, dynamic> json) => Business(
        name: json["name"],
        email: json["email"],
        category: json["category"],
        type: json["type"],
        phone: json["phone"],
        vendorId: json["vendorID"],
        address: json["address"],
        state:
            json["state"] == null ? null : StateModel.fromJson(json["state"]),
        country: json["country"] == null
            ? null
            : StateModel.fromJson(json["country"]),
        city: json["city"] == null ? null : CityModel.fromJson(json["city"]),
      );
}

class Documents {
  final Cac? cac;
  final Cac? tin;
  final dynamic proofOfAddress;

  Documents({
    this.cac,
    this.tin,
    this.proofOfAddress,
  });

  factory Documents.fromJson(Map<String, dynamic> json) => Documents(
        cac: json["CAC"] == null ? null : Cac.fromJson(json["CAC"]),
        tin: json["TIN"] == null ? null : Cac.fromJson(json["TIN"]),
        proofOfAddress: json["proof_of_address"],
      );
}

class Cac {
  final String? identifier;
  final String? file;

  Cac({
    this.identifier,
    this.file,
  });

  factory Cac.fromJson(Map<String, dynamic> json) => Cac(
        identifier: json["identifier"],
        file: json["file"],
      );
}

class Finance {
  final int? bankId;
  final String? bankName;
  final String? accountNumber;
  final String? accountName;

  Finance({
    this.bankId,
    this.bankName,
    this.accountNumber,
    this.accountName,
  });

  factory Finance.fromJson(Map<String, dynamic> json) => Finance(
        bankId: json["bank_id"],
        bankName: json["bank_name"],
        accountNumber: json["account_number"],
        accountName: json["account_name"],
      );
}
