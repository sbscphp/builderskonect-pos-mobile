import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class SaleDetailsListTile extends StatelessWidget {
  const SaleDetailsListTile({
    super.key,
    this.onTap,
    required this.productImage,
    required this.productTitle,
    required this.subTitle,
    required this.sku,
    required this.price,
    required this.totalAmount,
    required this.quantity,
    this.discount,
  });
  final VoidCallback? onTap;
  final String productImage;
  final String productTitle;
  final String subTitle;
  final String sku;
  final String price;
  final String totalAmount;
  final String quantity;
  final String? discount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ProductWithSkuListTile(
            productImage: productImage,
            productTitle: productTitle,
            subTitle: subTitle,
            trailingWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  totalAmount,
                  style: textTheme.text14?.medium.copyWith(
                    color: colorScheme.primaryColor,
                  ),
                ),
                YBox(4),
                Text(
                  quantity.isNotEmpty ? "x$quantity " : '',
                  style: textTheme.text14,
                ),
              ],
            ),
          ),
          YBox(10),
          if (discount?.isNotEmpty ?? false)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Discount: ",
                        style: textTheme.text12?.medium.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                      TextSpan(
                        text: discount,
                        style: textTheme.text12?.medium.copyWith(
                          color: colorScheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
