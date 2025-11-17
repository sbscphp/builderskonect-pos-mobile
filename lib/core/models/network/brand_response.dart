import 'package:builders_konnect/core/core.dart';

class BrandsResponse {
  bool? error;
  String? message;
  List<Brand>? data;

  BrandsResponse({
    this.error,
    this.message,
    this.data,
  });

  factory BrandsResponse.fromJson(Map<String, dynamic> json) {
    return BrandsResponse(
      error: json['error'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => Brand.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class Brand {
  int? id;
  String? name;
  int? isActive;
  int? products;
  TextEditingController certificateNum = TextEditingController();
  TextEditingController expriryDate = TextEditingController();
  String? docUrl;
  DateTime? expireyDateTime;


  Brand({
    this.id,
    this.name,
    this.isActive,
    this.products,
  });

  // Helper getter to check if brand is active
  bool get active => isActive == 1;

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] as int?,
      name: json['name'] as String?,
      isActive: json['is_active'] as int?,
      products: json['products'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_active': isActive,
      'products': products,
    };
  }
}