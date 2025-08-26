import 'package:builders_konnect/core/core.dart';

class BaseVm extends ChangeNotifier {
  late ApiResponse apiResponse;

  final Map<int, bool> _busyStates = <int, bool>{};

  /// Returns the busy status for an object if it exists. Returns false if not present
  bool busy(Object? object) => _busyStates[object.hashCode] ?? false;

  /// Returns the busy status of the ViewModel
  bool get isBusy => busy(this);

  /// Sets the busy state for the object equal to the value passed in and notifies Listeners
  /// If you're using a primitive type the value SHOULD NOT BE CHANGED, since Hashcode uses == value
  void setBusyForObject(Object? object, bool value) {
    _busyStates[object.hashCode] = value;
    notifyListeners();
  }

  /// Marks the ViewModel as busy and calls notify listeners
  void setBusy(bool value) {
    setBusyForObject(this, value);
  }

  final Map<int, dynamic> _errorStates = <int, bool>{};

  /// Returns the error status for an object if it exists. Returns false if not present
  bool error(Object? object) => _errorStates[object.hashCode] ?? false;

  /// Returns the error existence status of the ViewModel
  bool get hasError => error(this);

  /// Sets the error state for the object equal to the value passed in and notifies Listeners
  /// If you're using a primitive type the value SHOULD NOT BE CHANGED, since Hashcode uses == value
  void setErrorForObject(Object? object, bool value) {
    _errorStates[object.hashCode] = value;
    notifyListeners();
  }

  /// Sets the error for the ViewModel
  void setError(bool error) {
    setErrorForObject(this, error);
  }

  reBuildUI() {
    notifyListeners();
  }

  reset() {}

  Future<ApiResponse<T>> performApiCall<T>({
    required String url,
    required Future<ApiResponse> Function({
      dynamic body,
      required String url,
      bool isFormData,
      bool addDeviceHeaders,
    }) method,
    Map<String, dynamic>? body,
    bool isFormData = false,
    bool addDeviceHeaders = false,
    required ApiResponse<T> Function(dynamic data) onSuccess,
    ApiResponse<T> Function(String errorMessage)? onError,
    String? busyObjectName,
    String? errorObjectName,
  }) async {
    try {
      setErrorForObject(errorObjectName ?? this, false);
      setBusyForObject(busyObjectName ?? this, true);

      apiResponse = await method(
        url: url,
        body: body,
        isFormData: isFormData,
        addDeviceHeaders: addDeviceHeaders,
      );

      if (!apiResponse.success) {
        setErrorForObject(errorObjectName ?? this, true);
        // Convert to generic type for failure case
        return ApiResponse<T>(
          success: apiResponse.success,
          message: apiResponse.message,
          code: apiResponse.code,
          data: null,
        );
      }
      return onSuccess(apiResponse.data);
    } catch (e) {
      setErrorForObject(errorObjectName ?? this, true);
      printty("error ${e.toString()}");
      if (onError != null) {
        return onError(e.toString());
      } else {
        // Default error handling with generic type
        return ApiResponse<T>(success: false, message: e.toString());
      }
    } finally {
      setBusyForObject(busyObjectName ?? this, false);
    }
  }
}
