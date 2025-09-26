import 'package:builders_konnect/core/core.dart';

class CustomerVm extends BaseVm {
  //page number
  int pageNumber = 1;
  int? lastPage;

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

  Future<ApiResponse> getCustomerOverview(
      {String? q,
      String? dateFilter,
      CustomType? type,
      bool paginate = true,
      String? busyObjectName = getState}) async {
    if (busyObjectName != paginateState) {
      pageNumber = 1;
    }
    UriBuilder uriBuilder =
        UriBuilder("/api/v1/merchants/customers?page=$pageNumber")
          ..addQueryParameterIfNotEmpty("q", q ?? '')
          ..addQueryParameterIfNotEmpty("type", type?.apiValue ?? "")
          ..addQueryParameterIfNotEmpty("date_filter", dateFilter ?? "")
          ..addQueryParameterIfNotEmpty("limit", '10')
          ..addQueryParameterIfNotEmpty("paginate", paginate ? '1' : '0');

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: busyObjectName,
      busyObjectName: busyObjectName,
      onSuccess: (data) {
        if (paginate) {
          final customerStats =
              customerStatsFromJson(json.encode(data['data']?['stats']));
          if (busyObjectName != paginateState) {
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
            pageNumber++;
            lastPage = data['data']?['data']?['last_page'];
          } else {
            if (type == null) {
              _customerData.addAll(customerDataListFromJson(
                  json.encode(data['data']?['data']?['data'])));
            } else if (type == CustomType.online) {
              _onlineCustomerData.addAll(customerDataListFromJson(
                  json.encode(data['data']?['data']?['data'])));
            } else if (type == CustomType.offline) {
              _walkInCustomerData.addAll(customerDataListFromJson(
                  json.encode(data['data']?['data']?['data'])));
            }
            pageNumber++;
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

  //page number
  int csReviewpageNumber = 1;
  int? csReviewlastPage;

  CustomerReviewOverviewModel? _customerReviewOverviewModel;

  List<ReviewsData> _customerReviews = [];
  List<ReviewsData> get customerReviews => _customerReviews;

  Future<ApiResponse> getCustomerReviewOverview(
      {required String customerId,
      String? q,
      bool paginate = true,
      String? busyObjectName = getState}) async {
    if (busyObjectName != paginateState) {
      csReviewpageNumber = 1;
    }
    UriBuilder uriBuilder =
        UriBuilder("/api/v1/merchants/reviews?page=$csReviewpageNumber")
          ..addQueryParameterIfNotEmpty("q", q ?? '')
          ..addQueryParameterIfNotEmpty("limit", '10')
          ..addQueryParameterIfNotEmpty("customer_id", customerId)
          ..addQueryParameterIfNotEmpty("paginate", paginate ? '1' : '0');

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: busyObjectName,
      busyObjectName: busyObjectName,
      onSuccess: (data) {
        _customerReviewOverviewModel =
            customerReviewOverviewModelFromJson(json.encode(data['data']));
        if (busyObjectName != paginateState) {
          _customerReviews = reviewsDataFromJson(
              json.encode(_customerReviewOverviewModel?.data?.data));
          csReviewpageNumber++;
          csReviewlastPage = _customerReviewOverviewModel?.data?.lastPage;
        } else {
          _customerReviews.addAll(reviewsDataFromJson(
              json.encode(_customerReviewOverviewModel?.data?.data)));
          csReviewpageNumber++;
        }
        return apiResponse;
      },
    );
  }

  //page number
  int csReturnpageNumber = 1;
  int? csReturnlastPage;

  List<ReturnDataModel> _customerReturns = [];
  List<ReturnDataModel> get customerReturns => _customerReturns;

  ReturnStats? _customerReturnStats;
  ReturnStats? get customerReturnStats => _customerReturnStats;

  Future<ApiResponse> getCustomerReturnsOverview(
      {required String customerId,
      String? q,
      bool paginate = true,
      String? busyObjectName = getState}) async {
    if (busyObjectName != paginateState) {
      csReturnpageNumber = 1;
    }
    UriBuilder uriBuilder =
        UriBuilder("/api/v1/merchants/returns?page=$csReturnpageNumber")
          ..addQueryParameterIfNotEmpty("q", q ?? '')
          ..addQueryParameterIfNotEmpty("limit", '10')
          ..addQueryParameterIfNotEmpty("customer_id", customerId)
          ..addQueryParameterIfNotEmpty("paginate", paginate ? '1' : '0');

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: busyObjectName,
      busyObjectName: busyObjectName,
      onSuccess: (data) {
        if (busyObjectName != paginateState) {
          _customerReturns =
              returnDataFromJson(json.encode(data['data']?['data']?['data']));
          _customerReturnStats =
              returnStatsFromJson(json.encode(data['data']?['stats']));
          csReturnpageNumber++;
          csReturnlastPage = data['data']?['data']?['last_page'];
        } else {
          _customerReturns.addAll(
              returnDataFromJson(json.encode(data['data']?['data']?['data'])));
          csReturnpageNumber++;
        }
        return apiResponse;
      },
    );
  }

  //page number
  int csOrderpageNumber = 1;
  int? csOrderlastPage;

  List<SalesOrdersModel> _customerOrders = [];
  List<SalesOrdersModel> get customerOrders => _customerOrders;

  SalesStats? _customerOrderStats;
  SalesStats? get customerOrderStats => _customerOrderStats;

  Future<ApiResponse> getCustomerOrderOverview(
      {required String customerId,
      String? q,
      bool paginate = true,
      String? busyObjectName = getState}) async {
    if (busyObjectName != paginateState) {
      csOrderpageNumber = 1;
    }
    UriBuilder uriBuilder =
        UriBuilder("/api/v1/merchants/sales-orders?page=$csOrderpageNumber")
          ..addQueryParameterIfNotEmpty("q", q ?? '')
          ..addQueryParameterIfNotEmpty("limit", '10')
          ..addQueryParameterIfNotEmpty("customer_id", customerId)
          ..addQueryParameterIfNotEmpty("paginate", paginate ? '1' : '0');

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: busyObjectName,
      busyObjectName: busyObjectName,
      onSuccess: (data) {
        if (busyObjectName != paginateState) {
          _customerOrders = salesOrderDataListFromJson(
              json.encode(data['data']?['data']?['data']));
          _customerOrderStats =
              salesStatsFromJson(json.encode(data['data']?['stats']));
          csOrderpageNumber++;
          csOrderlastPage = data['data']?['data']?['last_page'];
        } else {
          _customerOrders.addAll(salesOrderDataListFromJson(
              json.encode(data['data']?['data']?['data'])));
          csOrderpageNumber++;
        }
        return apiResponse;
      },
    );
  }

  ReviewsStatModel? _reviewsStats;
  ReviewsStatModel? get reviewsStats => _reviewsStats;
  List<ReviewsModel> _customersReviewModel = [];
  List<ReviewsModel> get customersReviewModel => _customersReviewModel;
  Future<ApiResponse> customerReviewProduct(
    String productId, {
    bool paginate = true,
  }) async {
    UriBuilder uriBuilder =
        UriBuilder("/api/v1/merchants/reviews?product_id=$productId")
          ..addQueryParameterIfNotEmpty("limit", '30')
          ..addQueryParameterIfNotEmpty("paginate", paginate ? '1' : '0');

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: viewState,
      busyObjectName: viewState,
      onSuccess: (data) {
        _reviewsStats =
            reviewsStatModelFromJson(json.encode(data['data']?['stats']));
        _customersReviewModel =
            reviewsModelFromJson(json.encode(data['data']?['data']?['data']));
        return apiResponse;
      },
    );
  }

  ReviewsStatModel? _vendorReviewsStats;
  ReviewsStatModel? get vendorReviewsStats => _vendorReviewsStats;
  List<ReviewsModel> _vendorReviewModel = [];
  List<ReviewsModel> get vendorReviewModel => _vendorReviewModel;
  Future<ApiResponse> vendorReviewProduct({
    bool paginate = true,
    String? busyObjectName = vendorReviewsState,
    String? q,
  }) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/merchants/reviews")
      ..addQueryParameterIfNotEmpty("q", q ?? '')
      ..addQueryParameterIfNotEmpty("limit", '30')
      ..addQueryParameterIfNotEmpty("paginate", paginate ? '1' : '0');

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: busyObjectName,
      busyObjectName: busyObjectName,
      onSuccess: (data) {
        if (paginate) {
          _vendorReviewsStats =
              reviewsStatModelFromJson(json.encode(data['data']?['stats']));
          _vendorReviewModel =
              reviewsModelFromJson(json.encode(data['data']?['data']?['data']));
        } else {
          _vendorReviewModel = reviewsModelFromJson(json.encode(data['data']));
        }
        return apiResponse;
      },
    );
  }

  Future<ApiResponse<ReviewsModel>> viewReview({
    required int reviewId,
  }) async {
    return await performApiCall<ReviewsModel>(
      url: "/api/v1/merchants/reviews/$reviewId",
      method: apiService.getWithAuth,
      errorObjectName: viewState,
      busyObjectName: viewState,
      onSuccess: (data) {
        return ApiResponse(
            success: true, data: ReviewsModel.fromJson(data["data"]));
      },
    );
  }

  Future<ApiResponse> sendResponse({
    required int reviewId,
    required String response,
  }) async {
    return await performApiCall(
      url: "/api/v1/merchants/reviews/$reviewId",
      method: apiService.putWithAuth,
      errorObjectName: rendResponse,
      busyObjectName: rendResponse,
      body: {"response": response},
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }
}

final customerVmodel = ChangeNotifierProvider((ref) => CustomerVm());
