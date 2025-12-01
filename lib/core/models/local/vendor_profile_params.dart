import 'package:builders_konnect/core/models/local/onboard_params.dart';

class VendorProfileParams {
  final String? name;
  final String? email;
  final String? category;
  final String? type;
  final String? phone;
  final String? address;
  final String? logo;
  final String? accountNumber;
  final String? bankId;
  final String? bankName;
  final String? accountName;
  final List<Media>? media;

  final String? stateId;
  final String? cityId;
  final String? postalCode;

  VendorProfileParams({
    this.name,
    this.email,
    this.category,
    this.type,
    this.phone,
    this.address,
    this.logo,
    this.accountNumber,
    this.bankId,
    this.bankName,
    this.accountName,
    this.media,
    this.stateId,
    this.cityId,
    this.postalCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'category': category,
      'type': type,
      'phone': phone,
      'address': address,
      'logo': logo,
      'accountNumber': accountNumber,
      'bankId': bankId,
      'bankName': bankName,
      'accountName': accountName,
      'media': media?.map((x) => x.toJson()).toList(),
      'state_id': stateId,
      'city_id': cityId,
      'postal_code': postalCode,
    };
  }
}
