import 'package:builders_konnect/core/core.dart';

class SalesVm extends BaseVm {
  SalesOverviewModel? _salesOverviewModel;
  SalesStats? get salesStats => _salesOverviewModel?.stats;
  List<SalesData> get salesData => _salesOverviewModel?.data?.data ?? [];

  Future<ApiResponse> getSalesOverview({
    String? q,
    String? salesType,
  }) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/merchants/sales-orders")
      ..addQueryParameterIfNotEmpty("q", q ?? '')
      ..addQueryParameterIfNotEmpty("sales_type", salesType ?? '')
      ..addQueryParameterIfNotEmpty("limit", '30')
      ..addQueryParameterIfNotEmpty("paginate", '1');

    _salesOverviewModel = null;
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: getState,
      busyObjectName: getState,
      onSuccess: (data) {
        _salesOverviewModel =
            salesOverviewModelFromJson(json.encode(data['data']));
        return apiResponse;
      },
    );
  }

  /// List of products in the current sales order
  List<ProductModel> productList = [];

  /// Currently selected customer data
  CustomerData? selectedCustomerData;

  SalesOrderAmountBreakdownModel? _salesOrderAmountBreakdownModel;
  SalesOrderAmountBreakdownModel? get salesOrderAmountBreakdownModel =>
      _salesOrderAmountBreakdownModel;

  /// Calculates the amount breakdown for the current sales order
  /// [discountId] Optional discount to apply to the order
  Future<ApiResponse> salesAmountBreakdown({String? discountId}) async {
    // Convert product list to line items
    final selectedProducts = productList
        .map((product) => LineItemParams(
              productId: product.id,
              quantity: product.quantity,
            ))
        .toList();

    // Clean and prepare line items
    final lineItems = selectedProducts.map((item) {
      final json = item.toJson();
      // json.removeWhere((key, value) => value == null || value == '');
      return json;
    }).toList();

    // Prepare request payload
    final payload = <String, dynamic>{
      'line_items': lineItems,
      'discount_id': discountId,
    };

    // Make API call
    return await performApiCall(
      url: '/api/v1/merchants/sales-orders/amount-breakdown',
      method: apiService.postWithAuth,
      errorObjectName: createState,
      busyObjectName: createState,
      body: payload,
      onSuccess: (data) {
        _salesOrderAmountBreakdownModel =
            salesOrderAmountBreakdownModelFromJson(json.encode(data['data']));
        return apiResponse;
      },
    );
  }

  /// Recursively removes null and empty string values from a map and its nested objects
  Map<String, dynamic> _cleanPayload(Map<String, dynamic> payload) {
    final cleanedPayload = <String, dynamic>{};
    
    payload.forEach((key, value) {
      if (value == null || value == "") {
        // Special handling for discount_id: set to empty string if null
        if (key == "discount_id" && value == null) {
          cleanedPayload[key] = "";
        }
        // Skip other null and empty string values
        return;
      }
      
      if (value is Map<String, dynamic>) {
        // Recursively clean nested maps
        final cleanedNestedMap = _cleanPayload(value);
        if (cleanedNestedMap.isNotEmpty) {
          cleanedPayload[key] = cleanedNestedMap;
        }
      } else if (value is List) {
        // Clean lists and their nested objects
        final cleanedList = value.map((item) {
          if (item is Map<String, dynamic>) {
            return _cleanPayload(item);
          }
          return item;
        }).where((item) => item != null && item != "").toList();
        
        if (cleanedList.isNotEmpty) {
          cleanedPayload[key] = cleanedList;
        }
      } else {
        // Keep non-null, non-empty values
        cleanedPayload[key] = value;
      }
    });
    
    return cleanedPayload;
  }

  Future<ApiResponse> salesOrderCheckout({
    required SalesCheckoutParams params,
  }) async {
    final payload = params.toJson();
    final cleanedPayload = _cleanPayload(payload);
    return await performApiCall(
      url: "/api/v1/merchants/sales-orders",
      method: apiService.postWithAuth,
      errorObjectName: createState,
      busyObjectName: createState,
      body: cleanedPayload,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

  List<PausedSalesModel> _pausedSales = [];
  List<PausedSalesModel> get pausedSales => _pausedSales;
  Future<ApiResponse> getDraftOverview({String? q}) async {
    UriBuilder uriBuilder =
        UriBuilder("/api/v1/merchants/sales-orders/drafts/overview")
          ..addQueryParameterIfNotEmpty("q", q ?? '')
          ..addQueryParameterIfNotEmpty("limit", '30')
          ..addQueryParameterIfNotEmpty("paginate", '1');

    _salesOverviewModel = null;
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: q == null ? draftSalesState : searchState,
      busyObjectName: q == null ? draftSalesState : searchState,
      onSuccess: (data) {
        _pausedSales =
            pausedSalesModelFromJson(json.encode(data['data']?['data']));

        return apiResponse;
      },
    );
  }

  // Order Analytics

  SalesAnalysisStat? _salesAnalysisStatModel;
  SalesAnalysisStat? get salesAnalysisStatModel => _salesAnalysisStatModel;
  Future<ApiResponse> getOrderStatAnalytics({
    String? dateFilter,
  }) async {
    UriBuilder uriBuilder =
        UriBuilder("/api/v1/merchants/sales-orders/analytics/stats")
          ..addQueryParameterIfNotEmpty("date_filter", dateFilter ?? '');

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: salesAnalysisStatState,
      busyObjectName: salesAnalysisStatState,
      onSuccess: (data) {
        _salesAnalysisStatModel =
            salesAnalysisStatFromJson(json.encode(data['data']));
        return apiResponse;
      },
    );
  }

  List<TopSellingProduct> _topSellingProducts = [];
  List<TopSellingProduct> get topSellingProducts => _topSellingProducts;
  Future<ApiResponse> getTopSellingProducts({
    String? dateFilter,
    String? salesType,
  }) async {
    UriBuilder uriBuilder = UriBuilder(
        "/api/v1/merchants/sales-orders/analytics/top-selling-products")
      ..addQueryParameterIfNotEmpty("date_filter", dateFilter ?? '')
      ..addQueryParameterIfNotEmpty("sales_type", salesType ?? '');

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: topSellingProductsState,
      busyObjectName: topSellingProductsState,
      onSuccess: (data) {
        _topSellingProducts =
            topSellingProductFromJson(json.encode(data['data']));
        return apiResponse;
      },
    );
  }

  SalesOrdersModel? _salesOrdersModel;
  SalesOrdersModel? get salesOrdersModel => _salesOrdersModel;
  Future<ApiResponse> getSalesOrderDetails(String id) async {
    _salesOrdersModel = null;
    return await performApiCall(
      url: "/api/v1/merchants/sales-orders/$id",
      method: apiService.getWithAuth,
      errorObjectName: viewState,
      busyObjectName: viewState,
      onSuccess: (data) {
        _salesOrdersModel = salesOrdersModelFromJson(json.encode(data['data']));
        return apiResponse;
      },
    );
  }
}

final salesVmodel = ChangeNotifierProvider((ref) => SalesVm());
