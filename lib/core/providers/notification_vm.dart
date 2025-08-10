import 'package:builders_konnect/core/core.dart';

class NotificationVm extends BaseVm {
  List<NotificationModel> _allNotifications = [];
  List<NotificationModel> get allNotifications => _allNotifications;
  List<NotificationModel> _unreadNotifications = [];
  List<NotificationModel> get unreadNotifications => _unreadNotifications;

  Future<ApiResponse> getNotifications({
    bool? unread,
    bool? grouped,
    String? limit,
    bool? paginate,
  }) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/shared/notifications")
      ..addQueryParameterIfNotEmpty("unread", unread?.toString() ?? '')
      ..addQueryParameterIfNotEmpty("grouped", grouped?.toString() ?? '')
      ..addQueryParameterIfNotEmpty("limit", limit ?? '')
      ..addQueryParameterIfNotEmpty("paginate", paginate?.toString() ?? '');
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      onSuccess: (data) {
        if (unread != null && unread != '') {
          _unreadNotifications = notificationModelFromJson(
              json.encode(data["data"]["notifications"]));
        } else {
          _allNotifications = notificationModelFromJson(
              json.encode(data["data"]["notifications"]));
        }
        return apiResponse;
      },
    );
  }
}

final notificationVmodel = ChangeNotifierProvider((ref) => NotificationVm());
