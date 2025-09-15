import 'package:builders_konnect/core/core.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class BarcodeScannerViewModel extends ChangeNotifier {
  bool _isScanning = false;
  bool _isFlashlightOn = false;
  String? _scannedCode;
  String? _errorMessage;

  bool get isScanning => _isScanning;
  bool get isFlashlightOn => _isFlashlightOn;
  String? get scannedCode => _scannedCode;
  String? get errorMessage => _errorMessage;

  Future<void> initializeScanner() async {
    try {
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to initialize scanner: $e';
      notifyListeners();
    }
  }

  Future<void> startScanning(BuildContext context) async {
    if (_isScanning) return;

    try {
      _isScanning = true;
      _errorMessage = null;
      notifyListeners();

      String? result = await SimpleBarcodeScanner.scanBarcode(
        context,
        barcodeAppBar: const BarcodeAppBar(
          appBarTitle: 'Scan Barcode',
          centerTitle: true,
          enableBackButton: true,
        ),
        isShowFlashIcon: true,
      );

      if (result != null && result.isNotEmpty) {
        _scannedCode = result;
        onBarcodeDetected(result);
      }
    } catch (e) {
      _errorMessage = 'Scanning failed: $e';
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }

  void onBarcodeDetected(String code) {
    _scannedCode = code;
    notifyListeners();
    // You can add additional logic here, such as:
    // - Validating the barcode format
    // - Making API calls with the scanned data
    // - Navigating to another screen
    printty('Barcode detected: $code');
  }

  void toggleFlashlight() {
    // Note: simple_barcode_scanner doesn't provide direct flashlight control
    // The flashlight is controlled through the scanner UI
    _isFlashlightOn = !_isFlashlightOn;
    notifyListeners();
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }
}
