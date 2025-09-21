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

  /// List of products in the current transfer order
  List<ProductModel> productList = [];

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
        // getDashboardStats();
        return apiResponse;
      },
    );
  }

  TransferProductModel? _transferProduct;
  TransferProductModel? get transferProduct => _transferProduct;

  List<LineItemProduct> lineItems = [];
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
}

final productTransferVm = ChangeNotifierProvider((ref) => ProductTransferVm());
