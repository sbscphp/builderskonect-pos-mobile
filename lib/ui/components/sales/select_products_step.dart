import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class SelectProductsStep extends ConsumerStatefulWidget {
  const SelectProductsStep({
    super.key,
    this.onNext,
  });

  final Function()? onNext;

  @override
  ConsumerState<SelectProductsStep> createState() => _SelectProductsTabState();
}

class _SelectProductsTabState extends ConsumerState<SelectProductsStep> {
  final searchC = TextEditingController();
  final searchF = FocusNode();

  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    searchC.addListener(() {
      isSearching = searchC.text.isNotEmpty && searchF.hasFocus;
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchC.dispose();
    searchF.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
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
              CustomTextField(
                controller: searchC,
                focusNode: searchF,
                isRequired: false,
                labelText: 'Search Products ',
                hintText: 'Search product by name, sku, etc.',
                showLabelHeader: true,
              ),
              AnimatedSize(
                duration: Duration(milliseconds: 500),
                child: !isSearching
                    ? SizedBox.shrink()
                    : Container(
                        margin: EdgeInsets.only(top: Sizer.height(8)),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(Sizer.radius(2)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        constraints: BoxConstraints(
                          maxHeight: Sizer.height(300),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                            top: Sizer.height(16),
                            bottom: Sizer.height(30),
                          ),
                          itemCount: 10,
                          separatorBuilder: (_, __) => HDivider(),
                          itemBuilder: (ctx, i) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Sizer.width(16),
                              ),
                              child: SalesProductWidget(
                                productTitle: "Product Title",
                                subTitle: "10kg Smooth",
                                productImage: "https://picsum.photos/200",
                                sku: "71983753629",
                              ),
                            );
                          },
                        ),
                      ),
              ),
              YBox(24),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizer.width(16),
                  vertical: Sizer.height(12),
                ),
                decoration: BoxDecoration(
                  color: AppColors.neutral3,
                  borderRadius: BorderRadius.circular(Sizer.radius(4)),
                  border: Border.all(
                    color: AppColors.neutral5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppSvgs.scan),
                    XBox(8),
                    Text(
                      'Tap here to scan product barcode',
                      style: textTheme.text14?.copyWith(
                        color: AppColors.neutral10,
                      ),
                    ),
                  ],
                ),
              ),
              HDivider(verticalPadding: 24),
              Text(
                "Product list",
                style: textTheme.text16?.medium,
              ),
              YBox(16),
              ListView.separated(
                shrinkWrap: true,
                itemCount: 10,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => HDivider(),
                itemBuilder: (ctx, i) {
                  return SalesProductWidget(
                    productTitle: "Product Title",
                    subTitle: "10kg Smooth",
                    productImage: "https://picsum.photos/200",
                    sku: "71983753629",
                    showPriceQty: true,
                  );
                },
              ),
              HDivider(verticalPadding: 24),
              YBox(16),
              CustomBtn(
                text: "Next",
                onTap: widget.onNext,
              ),
              YBox(30),
            ],
          ),
        ),
      ],
    );
  }
}
