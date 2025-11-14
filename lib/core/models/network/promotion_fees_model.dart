class PromotionFeesResponse {
  bool? error;
  String? message;
  List<FeeData>? data;

  PromotionFeesResponse({
    this.error,
    this.message,
    this.data,
  });

  factory PromotionFeesResponse.fromJson(Map<String, dynamic> json) {
    return PromotionFeesResponse(
      error: json['error'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => FeeData.fromJson(item as Map<String, dynamic>))
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

class FeeData {
  int? id;
  String? identifierNo;
  String? name;
  String? code;
  bool? isActive;
  String? editableFields;
  bool? isDeletable;
  String? chargeUsage;
  String? chargeType;
  String? chargeCategory;
  num? chargeValue; // Using num to handle both int and double
  String? createdAt;
  String? updatedAt;

  FeeData({
    this.id,
    this.identifierNo,
    this.name,
    this.code,
    this.isActive,
    this.editableFields,
    this.isDeletable,
    this.chargeUsage,
    this.chargeType,
    this.chargeCategory,
    this.chargeValue,
    this.createdAt,
    this.updatedAt,
  });

  factory FeeData.fromJson(Map<String, dynamic> json) {
    return FeeData(
      id: json['id'] as int?,
      identifierNo: json['identifier_no'] as String?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      isActive: json['is_active'] as bool?,
      editableFields: json['editable_fields'] as String?,
      isDeletable: json['is_deletable'] as bool?,
      chargeUsage: json['charge_usage'] as String?,
      chargeType: json['charge_type'] as String?,
      chargeCategory: json['charge_category'] as String?,
      chargeValue: json['charge_value'] as num?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'identifier_no': identifierNo,
      'name': name,
      'code': code,
      'is_active': isActive,
      'editable_fields': editableFields,
      'is_deletable': isDeletable,
      'charge_usage': chargeUsage,
      'charge_type': chargeType,
      'charge_category': chargeCategory,
      'charge_value': chargeValue,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}