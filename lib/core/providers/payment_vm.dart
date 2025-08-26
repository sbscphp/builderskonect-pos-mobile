import 'package:builders_konnect/core/core.dart';

class PaymentVm extends BaseVm {
  List<PaymentMethodsModel> _paymentMethods = [];
  List<PaymentMethodsModel> get paymentMethods => _paymentMethods;
  Future<ApiResponse> getPaymentMethods() async {
    return await performApiCall(
      url: "/api/v1/shared/sales-payment-methods",
      method: apiService.getWithAuth,
      onSuccess: (data) {
        _paymentMethods =
            paymentMethodsModelFromJson(json.encode(data["data"]));
        return apiResponse;
      },
    );
  }
}

final paymentVmodel = ChangeNotifierProvider((ref) => PaymentVm());
