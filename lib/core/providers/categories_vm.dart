import 'package:builders_konnect/core/core.dart';

class CategoriesVm extends BaseVm {
  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;
  Future<ApiResponse> getCategories({
    bool paginate = false,
    String? table,
  }) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/shared/categorizations")
      ..addQueryParameterIfNotEmpty("table", table ?? 'inventory_products')
      ..addQueryParameterIfNotEmpty("level", 'category')
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
  }) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/shared/categorizations")
      ..addQueryParameterIfNotEmpty("parent_id", catId)
      ..addQueryParameterIfNotEmpty("table", table ?? 'inventory_products')
      ..addQueryParameterIfNotEmpty("level", 'subcategory')
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
  }) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/shared/categorizations")
      ..addQueryParameterIfNotEmpty("parent_id", catId)
      ..addQueryParameterIfNotEmpty("table", table ?? 'inventory_products')
      ..addQueryParameterIfNotEmpty("level", 'type')
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
    String? table,
  }) async {
    UriBuilder uriBuilder =
        UriBuilder("/api/v1/super_admin/platform-configurations/brands")
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
}

final categoryVmodel = ChangeNotifierProvider((ref) => CategoriesVm());
