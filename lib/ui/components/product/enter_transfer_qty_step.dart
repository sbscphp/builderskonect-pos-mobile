import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class EnterTransferQtyStep extends ConsumerStatefulWidget {
  const EnterTransferQtyStep({super.key});

  @override
  ConsumerState<EnterTransferQtyStep> createState() =>
      _EnterTransferQtyStepState();
}

class _EnterTransferQtyStepState extends ConsumerState<EnterTransferQtyStep> {
  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final vm = ref.watch(productTransferVm);

    return ListView(
      padding: EdgeInsets.only(
        left: Sizer.width(16),
        right: Sizer.width(16),
        bottom: Sizer.height(50),
      ),
      children: [
        YBox(16),
        Container(
          padding: EdgeInsets.all(Sizer.radius(16)),
          decoration: BoxDecoration(
            color: colorScheme.white,
            borderRadius: BorderRadius.circular(Sizer.radius(4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (vm.productList.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FilterHeader(
                      title: "Product List and Quantity",
                      subTitle: "Enter quantity to be requested",
                    ),
                    YBox(16),
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: vm.productList.length,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => HDivider(),
                      itemBuilder: (ctx, i) {
                        final product = vm.productList[i];
                        return TransferProductWidget(
                          productTitle: product.name ?? '',
                          subTitle: product.productType ?? '',
                          productImage: product.primaryMediaUrl ?? '',
                          sku: product.sku ?? '',
                          otherStore: vm.selectedStore?.name ?? '',
                          otherStock: product.transferItemDetails?.sourceQty
                              ?.toString(),
                          yourStock: product.transferItemDetails?.destinyQty
                              ?.toString(),
                          onChanged: (val) {
                            if(val.isEmpty) return;
                            //handle qty input here
                            if ((product.transferItemDetails?.sourceQty ?? 1) <
                                int.parse(val)) {
                              showWarningToast(
                                  'Request Quantity must be less than available stock');
                            } else {
                              product.requestQuantity = int.tryParse(val);
                            }
                            setState(() {});
                          },
                        );
                      },
                    ),
                    HDivider(verticalPadding: 24),
                    YBox(16),
                    // CustomBtn(
                    //   text: "Next",
                    //   onTap: widget.onNext,
                    // ),
                    // YBox(30),
                  ],
                ),
              YBox((vm.productList.isEmpty) ? 300 : 10),
              CustomBtn(
                text: "Next",
                online: vm.productList.isNotEmpty,
                onTap: () {
                  Navigator.pushNamed(
                      context, RoutePath.productTransferPreviewScreen);
                },
              ),
              YBox(30),
            ],
          ),
        ),
      ],
    );
  }
}
