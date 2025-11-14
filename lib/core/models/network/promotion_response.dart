class PromotionResponse {
  bool? error;
  String? message;
  PromotionData? data;

  PromotionResponse({
    this.error,
    this.message,
    this.data,
  });

  factory PromotionResponse.fromJson(Map<String, dynamic> json) {
    return PromotionResponse(
      error: json['error'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? PromotionData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class PromotionData {
  String? authorizationUrl;
  String? accessCode;
  String? reference;

  PromotionData({
    this.authorizationUrl,
    this.accessCode,
    this.reference,
  });

  factory PromotionData.fromJson(Map<String, dynamic> json) {
    return PromotionData(
      authorizationUrl: json['authorization_url'] as String?,
      accessCode: json['access_code'] as String?,
      reference: json['reference'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorization_url': authorizationUrl,
      'access_code': accessCode,
      'reference': reference,
    };
  }
}