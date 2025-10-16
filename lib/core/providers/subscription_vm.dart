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

  final List<UserSubcription> _subscriptionHistory = [];
  List<UserSubcription> get subscriptionHistory => _subscriptionHistory;

  // First subscription on list is current subscription
  UserSubcription? get currentSubscription =>
      _subscriptionHistory.isNotEmpty ? _subscriptionHistory[0] : null;
  Future<ApiResponse> getSubcriptionHistory({
    String? q,
    String? dateFilter,
    String? status,
    String? sortBy,
  }) async {
    UriBuilder uri = UriBuilder("/api/v1/merchants/subscriptions")
      ..addQueryParameterIfNotEmpty("q", q ?? "")
      ..addQueryParameterIfNotEmpty("date_filter", dateFilter ?? "")
      ..addQueryParameterIfNotEmpty("status", status ?? "")
      ..addQueryParameterIfNotEmpty("sort_by", sortBy ?? "");

    return await performApiCall(
      url: uri.build().toString(),
      method: apiService.get,
      onSuccess: (data) {
        _subscriptionHistory.clear();
        _subscriptionHistory
            .addAll(userSubcriptionFromJson(json.encode(data["data"])));
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> cancelSubscription(String subId) async {
    return await performApiCall(
      url: "/api/v1/merchants/subscriptions/$subId/cancel",
      method: apiService.getWithAuth,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

  // This returs payment authorize url
  Future<ApiResponse> selectInitialPlan(
      {required String priceItemId,
      String provider = "paystack",
      String? callbackUrl,
      String? discount}) async {
    final payload = {
      "price_item_id": priceItemId,
      "provider": provider,
      "callback_url": callbackUrl,
      "discount": discount,
    };
    payload.removeWhere((k, v) => v == null || v == "");
    return await performApiCall(
      url: "/api/v1/merchants/subscriptions/plan/initiate",
      method: apiService.postWithAuth,
      body: payload,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> subscribePlanVerify(String reference) async {
    return await performApiCall(
      url: "/api/v1/merchants/subscriptions/$reference/verify",
      method: apiService.getWithAuth,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }
}

final subscriptionVModel = ChangeNotifierProvider((ref) => SubscriptionVm());
