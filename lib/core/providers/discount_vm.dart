import 'package:builders_konnect/core/core.dart';

class DiscountVm extends BaseVm {
  DiscountOverviewViewModel? _discountOverviewModel;
  DiscountOverviewViewModel? get discountOverviewModel =>
      _discountOverviewModel;

  List<DiscountModel> _discounts = [];
  List<DiscountModel> get discounts => _discounts;

  Future<ApiResponse> getDashboardStats(
      {String q = '', bool isFirst = true}) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/merchants/discounts")
      ..addQueryParameterIfNotEmpty("paginate", "1")
      ..addQueryParameterIfNotEmpty("limit", "10")
      ..addQueryParameterIfNotEmpty('q', q);

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      busyObjectName: isFirst ? firstState : paginateState,
      onSuccess: (data) {
        _discountOverviewModel =
            discountOverviewViewModelFromJson(json.encode(data["data"]));
        _discounts = discountListFromJson(
            json.encode(_discountOverviewModel?.data?.data));

        return apiResponse;
      },
      onError: (errorMessage) {
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> addDiscount(
      {required String name,
      required String category,
      required String code,
      required String startDate,
      required String endDate,
      required String type,
      required bool isAllProducts,
      dynamic value}) async {
    final body = {
      "name": name,
      "code": code,
      "category": category,
      "start_date": startDate,
      "end_date": endDate,
      "type": type,
      "all_products": isAllProducts,
      "value": value,
    };

    return await performApiCall(
      url: "/api/v1/merchants/discounts",
      method: apiService.postWithAuth,
      body: body,
      onSuccess: (data) {
        getDashboardStats(isFirst: true);
        return apiResponse;
      },
      onError: (errorMessage) {
        return apiResponse;
      },
    );
  }
}

final discountVm = ChangeNotifierProvider((_) => DiscountVm());
