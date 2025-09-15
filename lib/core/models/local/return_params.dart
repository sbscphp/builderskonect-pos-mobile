class ReturnParams {
  final String? userId;
  final String? orderId;
  final String? orderLineItemId;
  final String? refundType;
  final String? returnReason;
  final String? description;
  final String? totalAmountRefunded;
  final String? quantity;
  final List<String>? media;

  ReturnParams({
    this.userId,
    this.orderId,
    this.orderLineItemId,
    this.refundType,
    this.returnReason,
    this.description,
    this.totalAmountRefunded,
    this.quantity,
    this.media,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'order_id': orderId,
      'order_line_item_id': orderLineItemId,
      'refund_type': refundType,
      'return_reason': returnReason,
      'description': description,
      'total_amount_refunded': totalAmountRefunded,
      'quantity': quantity,
      'media': media,
    };
  }
}
