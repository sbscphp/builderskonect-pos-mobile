import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ProductTransferRequestScreen extends ConsumerStatefulWidget {
  const ProductTransferRequestScreen({super.key});

  @override
  ConsumerState<ProductTransferRequestScreen> createState() =>
      _ProductTransferRequestScreenState();
}

class _ProductTransferRequestScreenState
    extends ConsumerState<ProductTransferRequestScreen> {
  int step = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "Product Transfer Request",
        onBack: () {
          if (step == 1) {
            Navigator.pop(context);

            // Clear product list and selected Store ID
            ref.read(productTransferVm).productList = [];
            ref.read(productTransferVm).selectedStore = null;
          } else {
            step--;
            setState(() {});
          }
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: Sizer.width(16),
              horizontal: Sizer.width(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RegSteps(
                  number: "1",
                  text: "Select Store",
                  isActive: step == 1,
                  passed: step > 1,
                ),
                RegSteps(
                  number: "2",
                  text: "Select Products",
                  isActive: step == 2,
                  passed: step > 2,
                ),
                RegSteps(
                  number: "3",
                  text: "Enter Quantity",
                  isActive: step == 3,
                  passed: step > 3,
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: switch (step) {
                1 => SelectStoreStep(
                    key: const ValueKey('select_store'),
                    onNext: () {
                      step = 2;
                      setState(() {});
                    },
                  ),
                2 => SelectTransferProductsStep(
                    key: const ValueKey('select_products'),
                    onNext: () {
                      step = 3;
                      setState(() {});
                    },
                  ),
                _ => EnterTransferQtyStep(
                    key: const ValueKey('order_summary'),
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
