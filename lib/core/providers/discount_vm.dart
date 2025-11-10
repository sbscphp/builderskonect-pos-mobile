import 'package:builders_konnect/core/core.dart';

class DiscountVm extends BaseVm {
  //page number
  int pageNumber = 1;
  int? lastPage;

  DiscountOverviewViewModel? _discountOverviewModel;
  DiscountOverviewViewModel? get discountOverviewModel =>
      _discountOverviewModel;

  List<DiscountModel> _discounts = [];
  List<DiscountModel> get discounts => _discounts;

  Future<ApiResponse> getDashboardStats(
      {String q = '',
      String? busyObjectName = firstState,
      String? dateFilter,
      String? status}) async {
    if (busyObjectName != paginateState) {
      pageNumber = 1;
    }
    UriBuilder uriBuilder =
        UriBuilder("/api/v1/merchants/discounts?page=$pageNumber")
          ..addQueryParameterIfNotEmpty("paginate", "1")
          ..addQueryParameterIfNotEmpty("limit", "10")
          ..addQueryParameterIfNotEmpty("limit", "10")
          ..addQueryParameterIfNotEmpty("date_filter", dateFilter ?? '')
          ..addQueryParameterIfNotEmpty("status", status ?? '')
          ..addQueryParameterIfNotEmpty('q', q);

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      busyObjectName: busyObjectName,
      onSuccess: (data) {
        if (busyObjectName != paginateState) {
          _discountOverviewModel =
              discountOverviewViewModelFromJson(json.encode(data["data"]));
          _discounts = discountListFromJson(
              json.encode(_discountOverviewModel?.data?.data));
          pageNumber++;
          lastPage = _discountOverviewModel?.data?.lastPage;
        } else {
          _discountOverviewModel =
              discountOverviewViewModelFromJson(json.encode(data["data"]));
          _discounts.addAll(discountListFromJson(
              json.encode(_discountOverviewModel?.data?.data)));
          pageNumber++;
        }

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
      dynamic value,
      List? products}) async {
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

    if (isAllProducts == false) {
      body["discounted_products"] = products;
    }

    return await performApiCall(
      url: "/api/v1/merchants/discounts",
      method: apiService.postWithAuth,
      body: body,
      onSuccess: (data) {
        getDashboardStats();
        return apiResponse;
      },
    );
  }
}

final discountVm = ChangeNotifierProvider((_) => DiscountVm());
