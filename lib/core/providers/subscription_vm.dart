import 'package:builders_konnect/core/core.dart';

const String confirmSubState = "confirmSubState";

class SubscriptionVm extends BaseVm {
  List<SubscriptionPlan> _subscriptionPlans = [];
  List<SubscriptionPlan> get subscriptionPlans => _subscriptionPlans;
  Future<ApiResponse> getSubscriptionPlans() async {
    return await performApiCall(
      url: "/api/v1/shared/subscription-plans",
      method: apiService.get,
      onSuccess: (data) {
        _subscriptionPlans =
            subscriptionPlanFromJson(json.encode(data["data"]));
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> subscribePlan(
    SubcribePlanParams params,
  ) async {
    final payload = params.toMap();
    payload.removeWhere((k, v) => v == null || v == "");
    return await performApiCall(
      url: "/api/v1/merchants/onboarding/subscribe",
      method: apiService.post,
      body: payload,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

  Future<ApiResponse<PlanBreakDownModel>> subscriptionBreakDown({
    required String priceItemId,
    String? discountCode,
    bool showDiscountState = false,
  }) async {
    final payload = {
      "price_item_id": priceItemId,
      "discount_code": discountCode,
    };
    payload.removeWhere((k, v) => v == null || v == "");
    return await performApiCall<PlanBreakDownModel>(
      url: "/api/v1/merchants/onboarding/subscription-breakdown",
      method: apiService.post,
      busyObjectName: showDiscountState ? discountState : null,
      body: payload,
      onSuccess: (data) {
        final res = planBreakDownFromJson(json.encode(data["data"]));
        return ApiResponse(success: true, data: res);
      },
    );
  }

  Future<ApiResponse<SubscriptionVerifcationModel>> verifySubscription({
    required String reference,
  }) async {
    return await performApiCall<SubscriptionVerifcationModel>(
      url: "/api/v1/merchants/onboarding/verify-subscription/$reference",
      method: apiService.get,
      busyObjectName: confirmSubState,
      onSuccess: (data) {
        final res =
            subscriptionVerifcationModelFromJson(json.encode(data["data"]));
        return ApiResponse<SubscriptionVerifcationModel>(
            success: true, data: res);
      },
    );
  }
}

final subscriptionVModel = ChangeNotifierProvider((ref) => SubscriptionVm());
