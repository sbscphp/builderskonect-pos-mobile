import 'dart:async';

import 'package:builders_konnect/core/core.dart';

class SalesVm extends BaseVm {
  //page number
  int pageNumber = 1;
  int? lastPage;

  SalesStats? _salesStats;
  SalesStats? get salesStats => _salesStats;
  List<SalesData> _salesData = [];
  List<SalesData> get salesData => _salesData;

  Future<ApiResponse> getSalesOverview({
    String? q,
    String? dateFilter,
    String? status,
    String? salesType,
    String? stateObjectName,
    String? customerId,
    bool paginate = true,
  }) async {
    if (stateObjectName != paginateState) {
      pageNumber = 1;
    }
    UriBuilder uriBuilder =
        UriBuilder("/api/v1/merchants/sales-orders?page=$pageNumber")
          ..addQueryParameterIfNotEmpty("q", q ?? '')
          ..addQueryParameterIfNotEmpty("customer_id", customerId ?? '')
          ..addQueryParameterIfNotEmpty("sales_type", salesType ?? '')
          ..addQueryParameterIfNotEmpty("date_filter", dateFilter ?? '')
          ..addQueryParameterIfNotEmpty("status", status ?? '')
          ..addQueryParameterIfNotEmpty("limit", '10')
          ..addQueryParameterIfNotEmpty("paginate", paginate ? '1' : '0');

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: stateObjectName ?? getState,
      busyObjectName: stateObjectName ?? getState,
      onSuccess: (data) {
        if (paginate) {
          _salesStats = salesStatsFromJson(json.encode(data['data']?['stats']));
          if (stateObjectName != paginateState) {
            _salesData =
                salesDataFromJson(json.encode(data['data']?['data']?['data']));
            pageNumber++;
            lastPage = data['data']?['data']?['last_page'];
          } else {
            _salesData.addAll(
                salesDataFromJson(json.encode(data['data']?['data']?['data'])));
            pageNumber++;
          }
        } else {
          _salesData = salesDataFromJson(json.encode(data?['data']));
        }
        return apiResponse;
      },
    );
  }

  /// List of products in the current sales order
  List<ProductModel> productList = [];

  /// Currently selected customer data
  CustomerData? selectedCustomerData;

  // Offline-specific properties
  List<OfflineSalesOrder> _offlineSalesOrders = [];
  List<OfflineSalesOrder> get offlineSalesOrders => _offlineSalesOrders;

  StreamSubscription<SyncEvent>? _syncEventSubscription;

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
        final cleanedList = value
            .map((item) {
              if (item is Map<String, dynamic>) {
                return _cleanPayload(item);
              }
              return item;
            })
            .where((item) => item != null && item != "")
            .toList();

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

  Future<ApiResponse> createPauseSales({
    required Order params,
  }) async {
    final payload = params.toJson();
    final cleanedPayload = _cleanPayload(payload);
    return await performApiCall(
      url: "/api/v1/merchants/sales-orders/drafts",
      method: apiService.postWithAuth,
      errorObjectName: pauseSalesState,
      busyObjectName: pauseSalesState,
      body: cleanedPayload,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

  // selected pause to resume
  PausedSalesModel? _selectedPausedSalesModel;
  PausedSalesModel? get selectedPausedSalesModel => _selectedPausedSalesModel;
  setSelectedPausedSalesModel(PausedSalesModel? value) {
    _selectedPausedSalesModel = value;
  }

  List<PausedSalesModel> _pausedSales = [];
  List<PausedSalesModel> get pausedSales => _pausedSales;
  Future<ApiResponse> getDraftOverview({String? q}) async {
    UriBuilder uriBuilder =
        UriBuilder("/api/v1/merchants/sales-orders/drafts/overview")
          ..addQueryParameterIfNotEmpty("q", q ?? '')
          ..addQueryParameterIfNotEmpty("limit", '30')
          ..addQueryParameterIfNotEmpty("paginate", '1');

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

  Future<ApiResponse> updateSalesOrderStatus({
    required String id,
    String? orderStatus, //failed, completed (update draft sales)
    String? paymentStatus, // paid, failed (confirm payment)
  }) async {
    final body = {
      "status": orderStatus,
      "payment_status": paymentStatus,
    }..removeWhere((k, v) => v == null || v == '');
    return await performApiCall(
      url: "/api/v1/merchants/sales-orders/$id",
      method: apiService.putWithAuth,
      errorObjectName: updateState,
      busyObjectName: updateState,
      body: body,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

  // Offline-specific methods

  /// Initialize offline functionality
  void initializeOfflineSupport() {
    _syncEventSubscription = SalesSyncService.instance.syncEventStream.listen(
      _onSyncEvent,
      onError: (error) {
        printty('SalesVm sync event stream error: $error', logName: 'SalesVm');
      },
    );

    // Load offline orders
    _loadOfflineOrders();
  }

  // Connectivity getters that delegate to ConnectivityService
  bool get isOfflineMode => !ConnectivityService.instance.isOnline;
  ConnectivityState get connectivityState =>
      ConnectivityService.instance.currentState;

  /// Handle sync events
  void _onSyncEvent(SyncEvent event) {
    printty('SalesVm sync event: ${event.type.name}', logName: 'SalesVm');

    // Reload offline orders when sync completes
    if (event.type == SyncEventType.completed) {
      _loadOfflineOrders();
    }
  }

  /// Load offline orders from database
  Future<void> _loadOfflineOrders() async {
    try {
      _offlineSalesOrders =
          await OfflineSalesDatabaseService.getAllOfflineSalesOrders();
      notifyListeners();
    } catch (e) {
      printty('Error loading offline orders: $e', logName: 'SalesVm');
    }
  }

  /// Create offline sales order (offline-first approach)
  Future<ApiResponse> createOfflineSalesOrder({
    required Order order,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Always save locally first
      final offlineOrder =
          await OfflineSalesDatabaseService.createOfflineSalesOrder(
        order: order,
        metadata: metadata,
      );

      // Add to local list
      _offlineSalesOrders.insert(0, offlineOrder);
      notifyListeners();

      // If online, try to sync immediately
      if (ConnectivityService.instance.isOnline) {
        // Trigger sync in background
        SalesSyncService.instance.syncPendingOrders();
      }

      return ApiResponse(
        success: true,
        message: isOfflineMode
            ? 'Order saved offline. Will sync when connection is restored.'
            : 'Order created successfully.',
        data: {'local_id': offlineOrder.localId},
      );
    } catch (e) {
      printty('Error creating offline sales order: $e', logName: 'SalesVm');
      return ApiResponse(
        success: false,
        message: 'Failed to create order: $e',
      );
    }
  }

  /// Enhanced sales order checkout with offline support
  Future<ApiResponse> salesOrderCheckoutOfflineFirst({
    required SalesCheckoutParams params,
  }) async {
    // If offline, save locally
    // if (isOfflineMode) {
    //   if (params.orders?.isNotEmpty == true) {
    //     return await createOfflineSalesOrder(order: params.orders!.first);
    //   }
    //   return ApiResponse(success: false, message: 'No order data provided');
    // }

    // If online, try normal checkout first
    final onlineResult = await salesOrderCheckout(params: params);

    // If online checkout fails, save offline as fallback
    // if (!onlineResult.success) {
    //   if (params.orders?.isNotEmpty == true) {
    //     return await createOfflineSalesOrder(
    //       order: params.orders!.first,
    //       metadata: {'fallback_reason': 'online_checkout_failed'},
    //     );
    //   }
    // }

    return onlineResult;
  }

  /// Force sync all pending orders
  Future<void> forceSyncAllOrders() async {
    if (!ConnectivityService.instance.isOnline) {
      return;
    }

    await SalesSyncService.instance.forceSyncAll();
    await _loadOfflineOrders();
  }

  /// Get connectivity status text for UI
  String get connectivityStatusText =>
      ConnectivityService.instance.connectivityStatusText;

  /// Dispose offline resources
  @override
  void dispose() {
    _syncEventSubscription?.cancel();
    super.dispose();
  }
}

final salesVmodel = ChangeNotifierProvider((ref) {
  final vm = SalesVm();
  // Initialize offline support when the provider is created
  WidgetsBinding.instance.addPostFrameCallback((_) {
    vm.initializeOfflineSupport();
  });
  return vm;
});
