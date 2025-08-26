import 'package:builders_konnect/core/core.dart';

class CustomerVm extends BaseVm {
  setCustomerOverview(CustomerOverviewModel? model) {
    _customerOverviewModel = model;
    reBuildUI();
  }

  CustomerOverviewModel? _customerOverviewModel;
  List<CustomerData> get customerData =>
      _customerOverviewModel?.data?.data ?? [];

  Future<ApiResponse> getCustomerOverview({
    String? q,
  }) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/merchants/customers")
      ..addQueryParameterIfNotEmpty("q", q ?? '')
      ..addQueryParameterIfNotEmpty("limit", '30')
      ..addQueryParameterIfNotEmpty("paginate", '1');

    _customerOverviewModel = null;
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: getState,
      busyObjectName: getState,
      onSuccess: (data) {
        _customerOverviewModel =
            customerOverviewModelFromJson(json.encode(data['data']));
        return apiResponse;
      },
    );
  }
}

final customerVmodel = ChangeNotifierProvider((ref) => CustomerVm());
