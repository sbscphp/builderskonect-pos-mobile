import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ProductAmoutQtySelector extends ConsumerStatefulWidget {
  const ProductAmoutQtySelector({
    super.key,
    required this.unitPrice,
    required this.totalAmount,
    required this.quantity,
    this.onQtyChanged,
    this.onRemove,
  });

  final String unitPrice;
  final String totalAmount;
  final int quantity;
  final ValueChanged<int>? onQtyChanged;
  final Function()? onRemove;

  @override
  ConsumerState<ProductAmoutQtySelector> createState() =>
      _ProductAmoutQtySelectorState();
}

class _ProductAmoutQtySelectorState
    extends ConsumerState<ProductAmoutQtySelector> {
  final qtyC = TextEditingController();

  @override
  void initState() {
    super.initState();
    qtyC.text = widget.quantity.toString();
  }

  @override
  void dispose() {
    qtyC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        YBox(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Unit Price: ",
                    style: textTheme.text12?.medium.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                  TextSpan(
                    text: widget.unitPrice,
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
                    text: "Total Amount: ",
                    style: textTheme.text12?.medium.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                  TextSpan(
                    text: widget.totalAmount,
                    style: textTheme.text12?.medium.copyWith(
                      color: AppColors.neutral11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        YBox(10),
        Row(
          children: [
            Text(
              "Quantity:",
              style: textTheme.text12?.medium,
            ),
            Spacer(),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(Sizer.radius(6)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppColors.neutral5,
                    ),
                  ),
                  child: SvgPicture.asset(AppSvgs.minus),
                ),
                XBox(10),
                Container(
                  height: Sizer.height(32),
                  width: Sizer.width(40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppColors.neutral5,
                    ),
                  ),
                  child: TextFormField(
                    controller: qtyC,
                    textAlign: TextAlign.center,
                    style: textTheme.text14?.copyWith(
                      color: AppColors.neutral11,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        bottom: Sizer.height(10),
                      ),
                    ),
                  ),
                ),
                XBox(10),
                Container(
                  padding: EdgeInsets.all(Sizer.radius(6)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppColors.neutral5,
                    ),
                  ),
                  child: SvgPicture.asset(AppSvgs.plus),
                ),
              ],
            ),
          ],
        ),
        YBox(16),
        CustomBtn(
          onlineColor: AppColors.red1,
          outlineColor: AppColors.red1,
          height: 40,
          onTap: widget.onRemove,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppSvgs.trash,
                height: Sizer.height(14),
              ),
              XBox(8),
              Text(
                "Remove",
                style: textTheme.text14?.copyWith(
                  color: AppColors.red22,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
