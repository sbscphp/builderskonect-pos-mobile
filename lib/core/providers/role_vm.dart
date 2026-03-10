import 'dart:developer';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/core/models/local/grouped.dart';

class RoleVm extends BaseVm {
  List<RoleModel> _roles = [];
  List<RoleModel> get roles => _roles;

  Future<ApiResponse> getAvailableRoles({String q = ''}) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/merchants/roles")
      ..addQueryParameterIfNotEmpty("paginate", "0")
      ..addQueryParameterIfNotEmpty("q", q);

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      onSuccess: (data) {
        _roles = roleModelListFromJson(json.encode(data["data"]));
        return apiResponse;
      },
      onError: (errorMessage) {
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> createRole({
    required String name,
    required String description,
  }) async {
    final body = {
      "name": name,
      "description": description,
      "permissions": isAllSelected() ? "all" : selectedIds.toList()
    };
    // log(body.toString());
    return await performApiCall(
      url: "/api/v1/merchants/roles",
      body: body,
      method: apiService.postWithAuth,
      onSuccess: (data) {
        selectedIds.clear();
        getAvailableRoles();
        return apiResponse;
      },
      onError: (errorMessage) {
        return apiResponse;
      },
    );
  }

  Set<int> selectedIds = {};

  List<PermissionRole> _permissions = [];
  List<PermissionRole> get permissions => _permissions;

  List<Grouped<String, PermissionRole>> _groupedPermissions = [];
  List<Grouped<String, PermissionRole>> get groupedPermissions =>
      _groupedPermissions;

  //returns the total number of selected permissions
  int get selectedPermissions => selectedIds.length;

  //returns the total number of permissions received from backend
  int get totalPermissions => _permissions.length;

  //fetch permissions
  fetchPermissions() {
    print('grouped permissions length:::${_groupedPermissions.toString()}>>>');
  }

  //SELECT ALL//

  //bool value for 'select all' checkbox
  bool isAllSelected() {
    final allIds = _groupedPermissions
        .expand((group) => group.items)
        .map((e) => e.id)
        .whereType<int>();

    return allIds.every(selectedIds.contains);
  }

  //called when the checkbox for 'select all' is clicked
  void toggleSelectAll() {
    final allIds = _groupedPermissions
        .expand((group) => group.items)
        .map((e) => e.id)
        .whereType<int>()
        .toSet();

    final allSelected = allIds.every(selectedIds.contains);

    if (allSelected) {
      selectedIds.clear();
    } else {
      selectedIds.addAll(allIds);
    }

    notifyListeners();
  }

  //PARENT//

  //called when the checkbox of a parent is clicked
  void selectAllChildren({required int parentIndex}) {
    final ids = _groupedPermissions[parentIndex]
        .items
        .map((e) => e.id)
        .whereType<int>()
        .toSet();

    final allSelected = ids.every(selectedIds.contains);

    if (allSelected) {
      selectedIds.removeAll(ids);
    } else {
      selectedIds.addAll(ids);
    }

    notifyListeners();
  }

  //bool value for parent checkbox
  bool isParentChecked({required int parentIndex}) {
    final ids = _groupedPermissions[parentIndex]
        .items
        .map((e) => e.id)
        .whereType<int>();

    return ids.any(selectedIds.contains);
  }

  //called when the checkbox of a parent is clicked
  void toggleParent({required int parentIndex}) {
    final ids = _groupedPermissions[parentIndex]
        .items
        .map((e) => e.id)
        .whereType<int>()
        .toSet();

    final allSelected = ids.every(selectedIds.contains);

    if (allSelected) {
      selectedIds.removeAll(ids);
    } else {
      selectedIds.addAll(ids);
    }

    notifyListeners();
  }

  //CHILD//

  //bool value for a child checkbox
  bool isChildChecked(int id) {
    return selectedIds.contains(id);
  }

  //called when the checkbox of a child is clicked
  void modifyList({required int id}) {
    if (!selectedIds.add(id)) {
      selectedIds.remove(id);
    }
    notifyListeners();
  }

  resetData() {
    selectedIds.clear();
    notifyListeners();
  }

  Future<ApiResponse> fetchRoles() async {
    return await performApiCall(
      url: "/api/v1/merchants/roles/permissions/all?paginate=0",
      method: apiService.getWithAuth,
      onSuccess: (data) {
        getAvailableRoles();
        _permissions = permissionRolesFromJson(json.encode(data["data"]));
        _groupedPermissions = AppUtils.groupBy<PermissionRole, String>(
          _permissions,
          (r) => r.module?.toLowerCase() ?? "",
        );

        return apiResponse;
      },
      onError: (errorMessage) {
        return apiResponse;
      },
    );
  }
}

final roleVm = ChangeNotifierProvider((_) => RoleVm());
