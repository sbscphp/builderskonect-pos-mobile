import 'package:builders_konnect/core/core.dart';

class OnboardVm extends BaseVm {
  // Get Business categorization
  List<BusinessCategoryTypeModel> _businessCategories = [];
  List<BusinessCategoryTypeModel> get businessCategories => _businessCategories;
  List<BusinessCategoryTypeModel> _businessTypes = [];
  List<BusinessCategoryTypeModel> get businessTypes => _businessTypes;
  Future<ApiResponse> getBusinessCategoryType(bool isCategory) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/shared/categorizations")
      ..addQueryParameterIfNotEmpty("paginate", "0")
      ..addQueryParameterIfNotEmpty("table", "tenant_information")
      ..addQueryParameterIfNotEmpty("level", isCategory ? "category" : "type");

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.get,
      onSuccess: (data) {
        final res =
            businessCategoryTypeModelFromJson(json.encode(data["data"]));
        if (isCategory) {
          _businessCategories = res;
        } else {
          _businessTypes = res;
        }
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> validateMerchantDetails({
    required OnboardParams onboardParams,
  }) async {
    final body = onboardParams.toJson();
    body.removeWhere((k, v) => v == null || v == "");
    return await performApiCall(
      url: "/api/v1/merchants/onboarding/validate-merchant-details",
      method: apiService.post,
      body: body,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> validateBank({
    required OnboardParams onboardParams,
  }) async {
    final body = onboardParams.toJson();
    body.removeWhere((k, v) => v == null || v == "");
    return await performApiCall(
      url: "/api/v1/merchants/onboarding/validate-bank",
      method: apiService.post,
      body: body,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> completeOnboarding({
    required OnboardParams onboardParams,
  }) async {
    final body = onboardParams.toJson();
    body.removeWhere((k, v) => v == null || v == "");
    return await performApiCall(
      url: "/api/v1/merchants/onboarding/complete",
      method: apiService.post,
      body: body,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }
}

final onboardVmodel = ChangeNotifierProvider<OnboardVm>((ref) => OnboardVm());
