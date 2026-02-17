import 'package:builders_konnect/core/core.dart';

/// Handles API response and shows appropriate toasts and executes callbacks
void handleApiResponse({
  required ApiResponse response,
  String? successMsg,
  bool showErrorToast = true,
  bool showSuccessToast = true,
  bool useBrandSuccessSnack = true,
  void Function()? onSuccess,
  void Function()? onError,
}) {
  if (response.success) {
    onSuccess?.call();

    if (showSuccessToast) {
      showSuccessToastMessage(
          successMsg ?? response.message ?? 'Operation successful',
          useBrandSuccessSnack: useBrandSuccessSnack);
    }
  } else {
    onError?.call();
    if (showErrorToast) {
      showWarningToast(response.message ?? 'Something went wrong');
    }
  }
}

/// Shows an error toast message
void showWarningToast(String msg) {
  FlushBarToast.fLSnackBar(message: msg);
}

/// Shows a success toast message
void showSuccessToastMessage(String msg, {bool useBrandSuccessSnack = true}) {
  FlushBarToast.fLSnackBar(
    message: msg,
    snackBarType:
        useBrandSuccessSnack ? SnackBarType.success : SnackBarType.successGreen,
  );
}
