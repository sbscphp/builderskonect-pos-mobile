import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final searchC = TextEditingController();
  final searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    searchC.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final productVm = ref.watch(productInventoryVmodel);
    return Scaffold(
        appBar: CustomAppbar(
          title: "Inventory",
        ),
        body: Builder(builder: (context) {
          if (productVm.busy(getState)) {
            return const Center(
              child: SizerLoader(
                height: double.infinity,
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await productVm.getInventoryProducts();
            },
            child: ListView(
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
                      FilterHeader(
                        title: "Inventory Overview",
                        subTitle: "View and manage products inventory.",
                      ),
                      YBox(16),
                      Container(
                        width: double.infinity,
                        height: Sizer.height(200),
                        padding: EdgeInsets.all(Sizer.radius(16)),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.blueDD9),
                          borderRadius: BorderRadius.circular(Sizer.radius(4)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProductColText(
                              title: "TOTAL PRODUCTS VALUE",
                              value:
                                  "${AppUtils.nairaSymbol}${AppUtils.formatNumber(decimalPlaces: 2, number: productVm.productStats?.totalProductsValue ?? 0)}",
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: ProductColText(
                                    textColor: colorScheme.black85,
                                    title: "Total Products",
                                    value: AppUtils.formatNumber(
                                        number: double.tryParse(productVm
                                                    .productStats
                                                    ?.totalProducts ??
                                                "0") ??
                                            0),
                                    valueTextSize: 12,
                                  ),
                                ),
                                Expanded(
                                  child: ProductColText(
                                    textColor: colorScheme.black85,
                                    title: "Available",
                                    value: AppUtils.formatNumber(
                                        number: double.tryParse(productVm
                                                    .productStats
                                                    ?.availableProducts ??
                                                "0") ??
                                            0),
                                    valueTextSize: 12,
                                    valueColor: AppColors.red2D,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: ProductColText(
                                    textColor: colorScheme.black85,
                                    title: "Sold-out Products",
                                    value: AppUtils.formatNumber(
                                        number: double.tryParse(productVm
                                                    .productStats
                                                    ?.totalSoldProducts ??
                                                "0") ??
                                            0),
                                    valueTextSize: 12,
                                    valueColor: AppColors.green1A,
                                  ),
                                ),
                                Expanded(
                                  child: ProductColText(
                                    textColor: colorScheme.black85,
                                    title: "Low Stocks",
                                    value: AppUtils.formatNumber(
                                        number: productVm.productStats
                                                ?.lowStockProducts ??
                                            0),
                                    valueTextSize: 12,
                                    valueColor: AppColors.red2D,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      YBox(40),
                      FilterHeader(
                        title: "Inventory List",
                        subTitle: "See all products in inventory",
                        onFilter: () {},
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: searchC,
                        focusNode: searchFocus,
                        isRequired: false,
                        showLabelHeader: false,
                        hintText: "Search by product id, name etc.",
                        onChanged: (value) {
                          setState(() {});
                        },
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (searchC.text.isNotEmpty)
                              InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: EdgeInsets.all(Sizer.width(10)),
                                  child: Icon(
                                    Icons.close,
                                    size: Sizer.width(20),
                                    color: AppColors.gray500,
                                  ),
                                ),
                              ),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(Sizer.width(10)),
                                decoration: BoxDecoration(
                                    border: Border(
                                  left: BorderSide(
                                    color: AppColors.neutral5,
                                  ),
                                )),
                                child: SvgPicture.asset(AppSvgs.search),
                              ),
                            ),
                          ],
                        ),
                      ),
                      YBox(10),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: Sizer.height(14),
                        ),
                        itemCount: 10,
                        separatorBuilder: (_, __) => HDivider(),
                        itemBuilder: (ctx, i) {
                          final product = productVm.inventoryProducts[i];
                          return ProductWithStatusListTile(
                            productImage: product.primaryMediaUrl ?? "",
                            productTitle: product.name ?? '',
                            subTitle: product.productType ?? '',
                            subTitle1: "Category: ",
                            subValue1: product.category ?? 'N/A',
                            subTitle2: "Stock level: ",
                            subValue2: "${product.quantity} left",
                            status: product.status ?? '',
                            onTap: () {
                              ModalWrapper.bottomSheet(
                                context: context,
                                widget: StoreOptionModal(options: [
                                  ModalOption(
                                    title: "View inventory details",
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RoutePath.viewProductDetailsScreen,
                                        arguments: product,
                                      );
                                    },
                                  ),
                                  ModalOption(
                                    title: "Edit inventory",
                                    onTap: () {
                                      ModalWrapper.bottomSheet(
                                        context: context,
                                        widget: EditInventoryModal(),
                                      );
                                    },
                                  ),
                                  ModalOption(
                                    title: "Trigger Re-order",
                                    textColor: AppColors.red2D,
                                    onTap: () {},
                                  ),
                                ]),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
