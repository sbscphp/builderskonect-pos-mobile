class PaymentBreakdownResponse {
  bool? error;
  String? message;
  PaymentBreakdownData? data;

  PaymentBreakdownResponse({
    this.error,
    this.message,
    this.data,
  });

  factory PaymentBreakdownResponse.fromJson(Map<String, dynamic> json) {
    return PaymentBreakdownResponse(
      error: json['error'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? PaymentBreakdownData.fromJson(json['data'] as Map<String, dynamic>)
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

class PaymentBreakdownData {
  String? duration;
  String? fee;
  String? otherFees;
  int? deluxeSeatAvailable;
  String? total;

  PaymentBreakdownData({
    this.duration,
    this.fee,
    this.otherFees,
    this.deluxeSeatAvailable,
    this.total,
  });

  factory PaymentBreakdownData.fromJson(Map<String, dynamic> json) {
    return PaymentBreakdownData(
      duration: json['duration'] as String?,
      fee: json['fee'] as String?,
      otherFees: json['other_fees'] as String?,
      deluxeSeatAvailable: json['deluxe_seat_available'] as int?,
      total: json['total'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'fee': fee,
      'other_fees': otherFees,
      'deluxe_seat_available': deluxeSeatAvailable,
      'total': total,
    };
  }
}