import 'package:builders_konnect/core/core.dart';

class CustomerVm extends BaseVm {
  CustomerStats? _customerStats;
  CustomerStats? get customerStats => _customerStats;
  CustomerStats? _onlineCustomerStats;
  CustomerStats? get onlineCustomerStats => _onlineCustomerStats;
  CustomerStats? _walkInCustomerStats;
  CustomerStats? get walkInCustomerStats => _walkInCustomerStats;

  List<CustomerData> _customerData = [];
  List<CustomerData> get customerData => _customerData;
  List<CustomerData> _onlineCustomerData = [];
  List<CustomerData> get onlineCustomerData => _onlineCustomerData;
  List<CustomerData> _walkInCustomerData = [];
  List<CustomerData> get walkInCustomerData => _walkInCustomerData;

  Future<ApiResponse> getCustomerOverview({
    String? q,
    CustomType? type,
    bool paginate = true,
  }) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/merchants/customers")
      ..addQueryParameterIfNotEmpty("q", q ?? '')
      ..addQueryParameterIfNotEmpty("type", type?.apiValue ?? "")
      ..addQueryParameterIfNotEmpty("limit", '30')
      ..addQueryParameterIfNotEmpty("paginate", paginate ? '1' : '0');

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: getState,
      busyObjectName: getState,
      onSuccess: (data) {
        if (paginate) {
          final customerStats =
              customerStatsFromJson(json.encode(data['data']?['stats']));
          final customerData = customerDataListFromJson(
              json.encode(data['data']?['data']?['data']));
          if (type == null) {
            _customerStats = customerStats;
            _customerData = customerData;
          } else if (type == CustomType.online) {
            _onlineCustomerStats = customerStats;
            _onlineCustomerData = customerData;
          } else if (type == CustomType.offline) {
            _walkInCustomerStats = customerStats;
            _walkInCustomerData = customerData;
          }
        } else {
          final customerData =
              customerDataListFromJson(json.encode(data['data']));
          if (type == null) {
            _customerData = customerData;
          } else if (type == CustomType.online) {
            _onlineCustomerData = customerData;
          } else if (type == CustomType.offline) {
            _walkInCustomerData = customerData;
          }
        }
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> createCustomers({
    required String name,
    required String email,
    required String phone,
    String? address,
    String? source,
  }) async {
    final payload = {
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
      "referral_source": source,
    };
    payload.removeWhere((k, v) => v == null || v == "");
    return await performApiCall(
      url: "/api/v1/merchants/customers",
      method: apiService.postWithAuth,
      errorObjectName: createState,
      busyObjectName: createState,
      body: payload,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

  CustomerData? _customerDetails;
  CustomerData? get customerDetails => _customerDetails;
  Future<ApiResponse> viewCustomerDetails(String id) async {
    return await performApiCall(
      url: "/api/v1/merchants/customers/$id",
      method: apiService.getWithAuth,
      errorObjectName: viewState,
      busyObjectName: viewState,
      onSuccess: (data) {
        _customerDetails = customerDataFromJson(json.encode(data['data']));
        return apiResponse;
      },
    );
  }

  // CustomerData? _customerDetails;
  // CustomerData? get customerDetails => _customerDetails;
  // Future<ApiResponse> viewCustomerDetails(String id) async {
  //   return await performApiCall(
  //     url: "/api/v1/merchants/customers/$id",
  //     method: apiService.getWithAuth,
  //     errorObjectName: viewState,
  //     busyObjectName: viewState,
  //     onSuccess: (data) {
  //       _customerDetails = customerDataFromJson(json.encode(data['data']));
  //       return apiResponse;
  //     },
  //   );
  // }
}

final customerVmodel = ChangeNotifierProvider((ref) => CustomerVm());
