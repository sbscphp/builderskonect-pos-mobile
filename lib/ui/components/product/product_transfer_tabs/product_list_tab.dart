import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ProductListTab extends ConsumerStatefulWidget {
  const ProductListTab({super.key});

  @override
  ConsumerState<ProductListTab> createState() => _ProductListTabState();
}

class _ProductListTabState extends ConsumerState<ProductListTab> {
  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(productTransferVm);

    final colorScheme = Theme.of(context).colorScheme;
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
          padding: EdgeInsets.all(Sizer.radius(16)),
          height: Sizer.screenHeight,
          decoration: BoxDecoration(
            color: colorScheme.white,
            borderRadius: BorderRadius.circular(Sizer.radius(4)),
          ),
          child: Column(
            children: [
              FilterHeader(title: "Product List"),
              YBox(16),
              ListView.separated(
                shrinkWrap: true,
                itemCount: vm.lineItems.length,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => HDivider(),
                itemBuilder: (ctx, i) {
                  final product = vm.lineItems[i];
                  final ctr = TextEditingController(
                      text: product.quantity?.toString() ?? '0');
                  return TransferProductWidget(
                    productTitle: product.name ?? '---',
                    subTitle: '---',
                    productImage: product.primaryMediaUrl ?? '',
                    sku: product.sku ?? '---',
                    onChanged: (val) {},
                    controller: ctr,
                    enabled: false,
                    showStock: false,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
