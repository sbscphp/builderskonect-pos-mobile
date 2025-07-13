import 'package:builders_konnect/core/core.dart';

void handleApiResponse({
  required ApiResponse response,
  String? successMsg,
  bool showErrorToast = true,
  bool showSuccessToast = true,
  void Function()? onSuccess,
  void Function()? onError,
}) {
  if (response.success) {
    if (onSuccess != null) onSuccess();
    if (showSuccessToast) {
      FlushBarToast.fLSnackBar(
          snackBarType: SnackBarType.success,
          message: successMsg ?? response.message ?? 'Operation successful');
    }
  } else {
    if (onError != null) onError();
    if (showErrorToast) {
      FlushBarToast.fLSnackBar(
          snackBarType: SnackBarType.warning,
          message: response.message ?? 'Something went wrong');
    }
  }
}
