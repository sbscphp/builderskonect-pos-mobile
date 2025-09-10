import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class BarcodeScannerScreen extends ConsumerStatefulWidget {
  const BarcodeScannerScreen({
    super.key,
    this.onBarcodeScanned,
    this.title = 'Scan Product Barcode',
  });

  final Function(String barcode)? onBarcodeScanned;
  final String title;

  @override
  ConsumerState<BarcodeScannerScreen> createState() =>
      _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends ConsumerState<BarcodeScannerScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _startScanning() async {
    try {
      String? result = await SimpleBarcodeScanner.scanBarcode(
        context,
        barcodeAppBar: const BarcodeAppBar(
          appBarTitle: 'Scan Product Barcode',
          centerTitle: false,
          enableBackButton: true,
        ),
        isShowFlashIcon: true,
        delayMillis: 2000,
      );

      if (result != null && result != '-1' && result.isNotEmpty) {
        widget.onBarcodeScanned?.call(result);
        if (mounted) {
          Navigator.of(context).pop(result);
        }
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error scanning barcode: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: textTheme.text20?.copyWith(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(Sizer.width(24)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_scanner,
                size: Sizer.radius(100),
                color: AppColors.primaryBlue,
              ),
              YBox(32),
              Text(
                'Ready to scan barcodes and QR codes',
                style: textTheme.headlineSmall?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              YBox(16),
              Text(
                'Tap the button below to open the camera scanner',
                style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              YBox(48),
              CustomBtn(
                text: 'Start Scanning',
                onTap: _startScanning,
              ),
              YBox(24),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: textTheme.bodyLarge?.copyWith(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
