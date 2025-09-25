import 'package:builders_konnect/core/core.dart';
import 'package:collection/collection.dart';

class StaffVm extends BaseVm {
  //page number
  int pageNumber = 1;
  int? lastPage;

  StaffOverviewModel? _staffOverviewModel;
  StaffOverviewModel? get staffOverviewModel => _staffOverviewModel;

  List<StaffModel> _staffs = [];
  List<StaffModel> get staffs => _staffs;

  Future<ApiResponse> getDashboardStats(
      {String q = '',
      bool isFirst = true,
      String? busyObjectName = firstState,
      String? dateFilter,
      String? status}) async {
    if (busyObjectName != paginateState) {
      pageNumber = 1;
    }
    UriBuilder uriBuilder =
        UriBuilder("/api/v1/merchants/staff?page=$pageNumber")
          ..addQueryParameterIfNotEmpty("paginate", "1")
          ..addQueryParameterIfNotEmpty("limit", "10")
          ..addQueryParameterIfNotEmpty("status", status ?? '')
          ..addQueryParameterIfNotEmpty("date_filter", dateFilter ?? '')
          ..addQueryParameterIfNotEmpty('q', q);

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      busyObjectName: busyObjectName,
      errorObjectName: busyObjectName,
      onSuccess: (data) {
        if (busyObjectName != paginateState) {
          _staffOverviewModel =
              staffOverviewModelFromJson(json.encode(data["data"]));
          _staffs = staffModelListFromJson(
              json.encode(_staffOverviewModel?.data?.data));
          pageNumber++;
          lastPage = _staffOverviewModel?.data?.lastPage;
        } else {
          _staffOverviewModel =
              staffOverviewModelFromJson(json.encode(data["data"]));
          _staffs.addAll(staffModelListFromJson(
              json.encode(_staffOverviewModel?.data?.data)));
          pageNumber++;
        }

        return apiResponse;
      },
    );
  }

  Future<ApiResponse> addNewStaff(
      {required String fullName,
      required String email,
      required String phone,
      dynamic roleId}) async {
    final body = {
      "name": fullName,
      "email": email,
      "phone": phone,
      "role_id": roleId,
    };

    return await performApiCall(
      url: "/api/v1/merchants/staff",
      method: apiService.postWithAuth,
      body: body,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

  StaffModel? _viewedStaff;
  StaffModel? get viewedStaff => _viewedStaff;

  Future<ApiResponse> viewStaff({required String staffID}) async {
    return await performApiCall(
      url: "/api/v1/merchants/staff/$staffID",
      method: apiService.getWithAuth,
      onSuccess: (data) {
        _viewedStaff = staffModelFromJson(json.encode(data["data"]));
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> updateStaff(
      {String? phone, int? isActive, dynamic roleId}) async {
    final body = {
      "phone": phone,
      "role_id": roleId,
      "is_active": isActive,
    }..removeWhere((key, value) => value == null);

    return await performApiCall(
      url: "/api/v1/merchants/staff/${_viewedStaff?.id}",
      body: body,
      method: apiService.putWithAuth,
      onSuccess: (data) {
        _viewedStaff = staffModelFromJson(json.encode(data["data"]));
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> requestApplicationAccess(String module) async {
    return await performApiCall(
      url: "/api/v1/merchants/access/application/$module/requests",
      method: apiService.getWithAuth,
      busyObjectName: module,
      onSuccess: (data) {
        _viewedStaff = staffModelFromJson(json.encode(data["data"]));
        return apiResponse;
      },
    );
  }

  List<ApplicationAccessModel> _applicationAccess = [];

  /// Helper method to check access for a specific role tag
  bool _hasAccessToRole(String roleTag) {
    final appAccess = _applicationAccess.firstWhereOrNull(
      (element) => element.tag?.toLowerCase() == roleTag.toLowerCase(),
    );
    return appAccess?.access ?? true;
  }

  bool get hasAccessToDashboardOverview =>
      _hasAccessToRole(RoleTags.dashboardOverview);
  bool get hasAccessToRevenueAnalytics =>
      _hasAccessToRole(RoleTags.revenueAnalytics);
  bool get hasAccessToCustomerOverview =>
      _hasAccessToRole(RoleTags.customerOverview);
  bool get hasAccessToRecentCustomers =>
      _hasAccessToRole(RoleTags.recentCustomers);
  bool get hasAccessToProductOverview =>
      _hasAccessToRole(RoleTags.productOverview);
  bool get hasAccessToNewProducts => _hasAccessToRole(RoleTags.newProducts);
  bool get hasAccessToVendorProfile => _hasAccessToRole(RoleTags.vendorProfile);
  bool get hasAccessToProduct => _hasAccessToRole(RoleTags.product);
  bool get hasAccessToSales => _hasAccessToRole(RoleTags.sales);
  bool get hasAccessToSalesAnalytics =>
      _hasAccessToRole(RoleTags.salesAnalytics);
  bool get hasAccessToReturns => _hasAccessToRole(RoleTags.returns);
  bool get hasAccessToCustomer => _hasAccessToRole(RoleTags.customer);
  bool get hasAccessToReview => _hasAccessToRole(RoleTags.review);
  bool get hasAccessToDiscount => _hasAccessToRole(RoleTags.discount);
  bool get hasAccessToStaff => _hasAccessToRole(RoleTags.staff);
  bool get hasAccessToReports => _hasAccessToRole(RoleTags.reports);

  Future<ApiResponse> getApplicationAccess() async {
    return await performApiCall(
      url: "/api/v1/merchants/access/application/access",
      method: apiService.getWithAuth,
      onSuccess: (data) {
        _applicationAccess =
            applicationAccessModelFromJson(json.encode(data["data"]));
        return apiResponse;
      },
    );
  }
}

final staffVm = ChangeNotifierProvider((_) => StaffVm());
