import 'package:builders_konnect/core/core.dart';

class CategoriesVm extends BaseVm {
  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;
  Future<ApiResponse> getCategories({
    bool paginate = false,
    String? table,
    String? q,
  }) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/shared/categorizations")
      ..addQueryParameterIfNotEmpty("table", table ?? 'inventory_products')
      ..addQueryParameterIfNotEmpty("level", 'category')
      ..addQueryParameterIfNotEmpty("q", q ?? '')
      ..addQueryParameterIfNotEmpty("paginate", paginate ? '1' : '0');

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: categoryState,
      busyObjectName: categoryState,
      onSuccess: (data) {
        _categories = categoryModelFromJson(json.encode(data['data']));
        return apiResponse;
      },
    );
  }

  List<CategoryModel> _subCategories = [];
  List<CategoryModel> get subCategories => _subCategories;
  Future<ApiResponse> getSubCategories(
    String catId, {
    bool paginate = false,
    String? table,
    String? q,
  }) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/shared/categorizations")
      ..addQueryParameterIfNotEmpty("parent_id", catId)
      ..addQueryParameterIfNotEmpty("table", table ?? 'inventory_products')
      ..addQueryParameterIfNotEmpty("level", 'subcategory')
      ..addQueryParameterIfNotEmpty("q", q ?? '')
      ..addQueryParameterIfNotEmpty("paginate", paginate ? '1' : '0');

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: subCategoryState,
      busyObjectName: subCategoryState,
      onSuccess: (data) {
        _subCategories = categoryModelFromJson(json.encode(data['data']));
        return apiResponse;
      },
    );
  }

  List<CategoryModel> _categoryTypes = [];
  List<CategoryModel> get categoryTypes => _categoryTypes;
  Future<ApiResponse> getCategoryType(
    String catId, {
    bool paginate = false,
    String? table,
    String? q,
  }) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/shared/categorizations")
      ..addQueryParameterIfNotEmpty("parent_id", catId)
      ..addQueryParameterIfNotEmpty("table", table ?? 'inventory_products')
      ..addQueryParameterIfNotEmpty("level", 'type')
      ..addQueryParameterIfNotEmpty("q", q ?? '')
      ..addQueryParameterIfNotEmpty("paginate", paginate ? '1' : '0');

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: catTypeState,
      busyObjectName: catTypeState,
      onSuccess: (data) {
        _categoryTypes = categoryModelFromJson(json.encode(data['data']));
        return apiResponse;
      },
    );
  }

  List<BrandModel> _brands = [];
  List<BrandModel> get brands => _brands;
  Future<ApiResponse> getBrands({
    bool paginate = false,
    String? q,
  }) async {
    UriBuilder uriBuilder =
        UriBuilder("/api/v1/super_admin/platform-configurations/brands")
          ..addQueryParameterIfNotEmpty("q", q ?? '')
          ..addQueryParameterIfNotEmpty("paginate", paginate ? '1' : '0');

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: brandState,
      busyObjectName: brandState,
      onSuccess: (data) {
        _brands = brandModelFromJson(json.encode(data['data']));
        return apiResponse;
      },
    );
  }

  Future<ApiResponse<BrandModel>> createBrands({
    required String brandName,
  }) async {
    return await performApiCall<BrandModel>(
      url: "/api/v1/super_admin/platform-configurations/brands",
      method: apiService.postWithAuth,
      errorObjectName: createState,
      busyObjectName: createState,
      body: {
        "name": brandName,
      },
      onSuccess: (data) {
        return ApiResponse(
          success: true,
          data: BrandModel.fromJson(data["data"]),
        );
      },
    );
  }
}

final categoryVmodel = ChangeNotifierProvider((ref) => CategoriesVm());
