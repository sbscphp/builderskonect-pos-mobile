import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class SalesProductWidget extends StatelessWidget {
  const SalesProductWidget({
    super.key,
    required this.productTitle,
    required this.productImage,
    required this.subTitle,
    required this.sku,
    this.unitPrice,
    this.totalAmount,
    this.quantity,
    this.showPriceQty = false,
    this.onTap,
  });

  final String productTitle;
  final String productImage;
  final String subTitle;
  final String sku;
  final String? unitPrice;
  final String? totalAmount;
  final int? quantity;
  final bool showPriceQty;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ProductWithSkuListTile(
            productTitle: productTitle,
            subTitle: subTitle,
            sku: sku,
          ),
          if (showPriceQty)
            ProductAmoutQtySelector(
              unitPrice: unitPrice ?? "",
              totalAmount: totalAmount ?? "",
              quantity: quantity ?? 1,
              // onQtyChanged: (value) {},
            ),
        ],
      ),
    );
  }
}
