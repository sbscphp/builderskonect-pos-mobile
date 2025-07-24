class SubcribePlanParams {
  final String? name;
  final String? company;
  final String? email;
  final String? phone;
  final String? priceItemId;
  final String? freeTrial;
  final String? provider;
  final String? callbackUrl;
  final String? dicountCode;

  SubcribePlanParams({
    this.name,
    this.company,
    this.email,
    this.phone,
    this.priceItemId,
    this.freeTrial,
    this.provider,
    this.callbackUrl,
    this.dicountCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'company': company,
      'email': email,
      'phone': phone,
      'price_item_id': priceItemId,
      'free_trial': freeTrial,
      'callback_url': callbackUrl,
      'provider': provider,
      'dicountCode': dicountCode,
    };
  }
}
