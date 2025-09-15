import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class RetrunOrderListTile extends StatelessWidget {
  const RetrunOrderListTile({
    super.key,
    required this.productTitle,
    required this.productImage,
    required this.subTitle,
    required this.sku,
    required this.amount,
    required this.qty,
    this.isSelected = false,
    this.showQtyTextfield = false,
    this.onSelect,
    this.qtyController,
    this.onQtyChanged,
  });

  final String productTitle;
  final String productImage;
  final String subTitle;
  final String sku;
  final String amount;
  final String qty;
  final bool isSelected;
  final bool showQtyTextfield;
  final Function()? onSelect;
  final TextEditingController? qtyController;
  final Function(String)? onQtyChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onSelect,
      child: Column(
        children: [
          Row(
            children: [
              CustomCheckbox(
                isSelected: isSelected,
                onTap: onSelect,
              ),
              XBox(8),
              Expanded(
                child: ProductWithSkuListTile(
                  productImage: productImage,
                  productTitle: productTitle,
                  subTitle: subTitle,
                  sku: sku,
                ),
              ),
            ],
          ),
          YBox(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Amount: ",
                      style: textTheme.text12?.medium.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                    TextSpan(
                      text: amount,
                      style: textTheme.text12?.medium.copyWith(
                        color: colorScheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Qty bought: ",
                      style: textTheme.text12?.medium.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                    TextSpan(
                      text: qty,
                      style: textTheme.text12?.medium.copyWith(
                        color: AppColors.neutral11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          YBox(8),
          if (showQtyTextfield)
            Row(
              children: [
                Text(
                  "Return Quantity:",
                  style: textTheme.text12?.medium,
                ),
                XBox(16),
                Expanded(
                  child: CustomTextField(
                    height: 40,
                    controller: qtyController,
                    hintText: 'Enter quantity',
                    showLabelHeader: false,
                    isRequired: false,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        final returnQty = int.tryParse(value);
                        final maxQty = int.tryParse(qty) ?? 0;
                        
                        if (returnQty == null || returnQty <= 0) {
                          showWarningToast('Please enter a valid quantity');
                          return;
                        }
                        
                        if (returnQty > maxQty) {
                          showWarningToast('Return quantity cannot exceed $maxQty');
                          return;
                        }
                      }
                      
                      if (onQtyChanged != null) {
                        onQtyChanged!(value);
                      }
                    },
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
