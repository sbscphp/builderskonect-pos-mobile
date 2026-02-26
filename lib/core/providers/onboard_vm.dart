import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/core/models/network/address.dart';

const String categoryTypeState = "categoryTypeState";

class OnboardVm extends BaseVm {
  OnboardParams? _vendorOnboardParams;
  OnboardParams? get vendorOnboardParams => _vendorOnboardParams;
  void setVendorOnboardParams(OnboardParams? params) {
    _vendorOnboardParams = params;
    reBuildUI();
  }

  OnboardParams? _bankOnboardParams;
  OnboardParams? get bankOnboardParams => _bankOnboardParams;
  void setBankOnboardParams(OnboardParams? params) {
    _bankOnboardParams = params;
    reBuildUI();
  }

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
      busyObjectName: categoryTypeState,
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

  //list of address suggestions
  List<Address> _addressSuggestions = [];
  List<Address> get addressSuggestions => _addressSuggestions;

  List<String> get addressNames =>
      _addressSuggestions.map((address) => address.name ?? 'N/A').toList();
  bool _showAddressList = false;
  bool get showAddressList => _showAddressList;
  set showAddressList(bool val) {
    _showAddressList = val;
    notifyListeners();
  }

  Future<ApiResponse> fetchAddressSuggestions(
      {required String? keyWord}) async {
    _showAddressList = true;
    return await performApiCall(
      url: "/api/v1/shared/search-address?q=$keyWord",
      method: apiService.get,
      busyObjectName: fetchAddressState,
      errorObjectName: fetchAddressState,
      onSuccess: (data) {
        final res = addressFromJson(json.encode(data["data"]));
        _addressSuggestions = res;
        return apiResponse;
      },
      onError: (errorMessage) {
        _showAddressList = false;
        return apiResponse;
      },
    );
  }

    resetAddressSuggestions(){
    _showAddressList = false;
    _addressSuggestions.clear();
  }

  Future<ApiResponse> completeOnboarding({
    required OnboardParams onboardParams,
  }) async {
    // Helper function to clean map data
    Map<String, dynamic> cleanMap(Map<String, dynamic>? map) {
      if (map == null) return {};
      final cleaned = Map<String, dynamic>.from(map);
      cleaned.removeWhere((_, v) => v == null || v == "");
      return cleaned;
    }

    // Clean and merge all details
    final body = {
      ...cleanMap(_vendorOnboardParams?.toJson()),
      ...cleanMap(_bankOnboardParams?.toJson()),
      ...cleanMap(onboardParams.toJson()),
    };

    return await performApiCall(
      url: "/api/v1/merchants/onboarding/complete",
      method: apiService.post,
      body: body,
      onSuccess: (data) => apiResponse,
    );
  }
}

final onboardVmodel = ChangeNotifierProvider<OnboardVm>((ref) => OnboardVm());
