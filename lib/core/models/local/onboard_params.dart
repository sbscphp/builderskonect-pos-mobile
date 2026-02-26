class OnboardParams {
  final String? businessName;
  final List<String>? categoryId;
  final String? businessType;
  final String? contactName;
  final String? email;
  final String? phone;
  final String? address;
  final int? stateId;
  final int? cityId;
  final String? accountNumber;
  final int? bankId;
  final String? accountName;
  final String? callbackUrl;
  final String? providerReference;
  final List<Media>? media;

  OnboardParams({
    this.businessName,
    this.categoryId,
    this.businessType,
    this.contactName,
    this.email,
    this.phone,
    this.address,
    this.stateId,
    this.cityId,
    this.accountNumber,
    this.bankId,
    this.accountName,
    this.callbackUrl,
    this.providerReference,
    this.media,
  });

  Map<String, dynamic> toJson() => {
        "business_name": businessName,
        "category_id": categoryId,
        "business_type": businessType,
        "contact_name": contactName,
        "email": email,
        "phone": phone,
        "address": address,
        "state_id": stateId,
        "city_id": cityId,
        "account_number": accountNumber,
        "bank_id": bankId,
        "account_name": accountName,
        "callback_url": callbackUrl,
        "provider_reference": providerReference,
        "media": media?.map((e) => e.toJson()).toList(),
      };
}

class Media {
  final String? name;
  final String? url;
  final Iddata? metadata;

  Media({
    this.name,
    this.url,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
        "metadata": metadata?.toJson(),
      };
}

class Iddata {
  final String? identificationNumber;

  Iddata({
    this.identificationNumber,
  });

  Map<String, dynamic> toJson() => {
        "identification_number": identificationNumber,
      };
}
