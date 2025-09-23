import 'package:builders_konnect/core/core.dart';

class ProductTransferVm extends BaseVm {
  //page number
  int pageNumber = 1;
  int? lastPage;

  TransferProductOverviewModel? _transferProductOverviewModel;
  double get stockValue => double.parse(
      _transferProductOverviewModel?.stats?.requestSentValue?.toString() ??
          '0');
  String get stockReceived =>
      _transferProductOverviewModel?.stats?.stockReceived?.toString() ?? '0';
  List<TransferProductModel> _transferProducts = [];
  List<TransferProductModel> get transferProducts => _transferProducts;

  Future<ApiResponse> getTransferProducts(
      {String? q,
      String? busyObjectName = getState,
      String? dateFilter,
      String? status}) async {
    if (busyObjectName != paginateState) {
      pageNumber = 1;
    }
    UriBuilder uriBuilder = UriBuilder(
        "/api/v1/merchants/inventory-products/transfers/all?page=$pageNumber")
      ..addQueryParameterIfNotEmpty("q", q ?? '')
      ..addQueryParameterIfNotEmpty("date_filter", dateFilter ?? '')
      ..addQueryParameterIfNotEmpty("status", status ?? '')
      ..addQueryParameterIfNotEmpty("limit", '20')
      ..addQueryParameterIfNotEmpty("paginate", '1');

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: busyObjectName,
      busyObjectName: busyObjectName,
      onSuccess: (data) {
        if (busyObjectName != paginateState) {
          _transferProductOverviewModel =
              transferProductOverviewModelFromJson(json.encode(data['data']));
          _transferProducts = transferProductListFromJson(
              json.encode(_transferProductOverviewModel?.data?.data));
          pageNumber++;
          lastPage = _transferProductOverviewModel?.data?.lastPage;
        } else {
          _transferProductOverviewModel =
              transferProductOverviewModelFromJson(json.encode(data['data']));
          _transferProducts.addAll(transferProductListFromJson(
              json.encode(_transferProductOverviewModel?.data?.data)));
          pageNumber++;
        }

        return apiResponse;
      },
    );
  }

  StoreModel? _selectedStore;
  StoreModel? get selectedStore => _selectedStore;
  set selectedStore(StoreModel? val) {
    _selectedStore = val;
    notifyListeners();
  }

  final storeC = TextEditingController();
  InventoryProductModel? _inventoryProductModel;
  List<ProductModel> _storeProducts = [];
  List<ProductModel> get storeProducts => _storeProducts;

  //Given that [_selectedStore] is not null fetch Store products by store ID
  Future<ApiResponse> fetchProductsByStoreId({String? q}) async {
    _inventoryProductModel = null;
    _storeProducts.clear();
    UriBuilder uriBuilder = UriBuilder("/api/v1/merchants/inventory-products")
      ..addQueryParameterIfNotEmpty("q", q ?? '')
      ..addQueryParameterIfNotEmpty("location_id", _selectedStore?.id ?? '')
      ..addQueryParameterIfNotEmpty("limit", '50')
      ..addQueryParameterIfNotEmpty("paginate", '1');

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: storeProductState,
      busyObjectName: storeProductState,
      onSuccess: (data) {
        _inventoryProductModel =
            inventoryProductModelFromJson(json.encode(data['data']));
        _storeProducts = _inventoryProductModel?.data?.data ?? [];

        return apiResponse;
      },
    );
  }

  //Updates product with Product Item Details
  Future<ApiResponse> fetchTransferItemDetail({ProductModel? product}) async {
    UriBuilder uriBuilder = UriBuilder(
        "/api/v1/merchants/inventory-products/transfers/line-item/details")
      ..addQueryParameterIfNotEmpty("product_id", product?.id ?? '')
      ..addQueryParameterIfNotEmpty("location_id", _selectedStore?.id ?? '');

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: transferItemState,
      busyObjectName: transferItemState,
      onSuccess: (data) {
        // product?.transferItemDetails =
        //     transferItemDetailsFromJson(json.encode(data['data']));
        // printty("AFTER CALL :::>>> ${product?.toJson()}");
        return apiResponse;
      },
    );
  }

  /// List of products in the current transfer order
  List<ProductModel> productList = [];

  TransferProductModel? createRequestModel;
  Future<ApiResponse> createProductTransfer() async {
    final body = {
      "line_items": productList
          .map((e) => {"product_id": e.id, "quantity": e.quantity})
          .toList(),
      "location_id": _selectedStore?.id,
      "type": "request",
    };

    return await performApiCall(
      url: "/api/v1/merchants/inventory-products/transfers",
      method: apiService.postWithAuth,
      body: body,
      busyObjectName: createState,
      onSuccess: (data) {
        createRequestModel = transferProductFromJson(json.encode(data['data']));
        getTransferProducts();
        _reset();
        return apiResponse;
      },
    );
  }

  _reset() {
    productList.clear();
    _storeProducts.clear();
    storeC.clear();
    _selectedStore = null;
    notifyListeners();
  }

  TransferProductModel? _transferProduct;
  TransferProductModel? get transferProduct => _transferProduct;

  List<LineItemProduct> lineItems = [];
  List<LineItemProduct> get approvedItems => lineItems
      .where((product) =>
          product.status == "received" || product.status == "approved")
      .toList();
  List<LineItemProduct> get rejectedItems =>
      lineItems.where((product) => product.status == "declined").toList();

  Future<ApiResponse> viewTransferProduct(String id) async {
    _transferProduct = null;
    return await performApiCall(
      url: "/api/v1/merchants/inventory-products/transfers/$id",
      method: apiService.getWithAuth,
      errorObjectName: viewState,
      busyObjectName: viewState,
      onSuccess: (data) {
        _transferProduct = transferProductFromJson(json.encode(data['data']));
        lineItems = lineitemProductListFromJson(
            jsonEncode(_transferProduct?.lineItems?.data));
        return apiResponse;
      },
    );
  }

  List<LineItemProduct> selectedActionProducts = [];

  Future<ApiResponse> updateTransferProduct(String status,
      {String? reason}) async {
    final body = {
      "reason": reason,
      "line_item_ids": selectedActionProducts.map((e) => e.id).toList(),
      "status": status
    };
    return await performApiCall(
      url:
          "/api/v1/merchants/inventory-products/transfers/${_transferProduct?.id ?? ''}",
      method: apiService.putWithAuth,
      errorObjectName: updateState,
      busyObjectName: updateState,
      body: body,
      onSuccess: (data) {
        selectedActionProducts.clear();
        viewTransferProduct(_transferProduct?.id ?? '');
        return apiResponse;
      },
    );
  }
}

final productTransferVm = ChangeNotifierProvider((ref) => ProductTransferVm());
