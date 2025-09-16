// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class InventoryDetailsScreen extends ConsumerStatefulWidget {
  const InventoryDetailsScreen({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  ConsumerState<InventoryDetailsScreen> createState() =>
      _InventoryDetailsScreenState();
}

class _InventoryDetailsScreenState
    extends ConsumerState<InventoryDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppbar(
        title: "View Inventory",
      ),
      body: ListView(
        padding: EdgeInsets.only(
          bottom: Sizer.height(50),
        ),
        children: [
          YBox(16),
          Container(
            margin: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
            padding: EdgeInsets.symmetric(
              horizontal: Sizer.width(16),
              vertical: Sizer.height(16),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizer.radius(4)),
              color: colorScheme.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilterHeader(
                  title: "User Profile",
                  subTitle: "See inventory details of the selected product",
                  // trailingWidget: NewButtonWidget(
                  //   onTap: () {
                  //     Navigator.pushNamed(
                  //         context, RoutePath.searchAddProductScreen);
                  //   },
                  // ),
                ),
                YBox(16),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Sizer.radius(16)),
                  decoration: BoxDecoration(
                    color: AppColors.neutral3,
                    borderRadius: BorderRadius.circular(Sizer.radius(4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileColText(
                        title: "Product Name",
                        subTitle: widget.product.name ?? "",
                      ),
                      YBox(16),
                      ProfileColText(
                        title: "Category",
                        subTitle: widget.product.category ?? "",
                      ),
                      YBox(16),
                      ProfileColText(
                          title: "Amount",
                          subTitle:
                              "${AppUtils.nairaSymbol}${widget.product.costPrice ?? ""}"),
                      YBox(16),
                      ProfileColText(
                        title: "Stock Level",
                        subTitle: widget.product.quantity?.toString() ?? "N/A",
                      ),
                      YBox(16),
                      ProfileColText(
                        title: "Re-order Level",
                        subTitle: widget.product.reorderValue ?? "N/A",
                      ),
                      YBox(16),
                      Text(
                        "Status",
                        style: textTheme.text12?.copyWith(
                          color: AppColors.grey175,
                        ),
                      ),
                      OrderStatus(status: widget.product.status ?? "N/A"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
