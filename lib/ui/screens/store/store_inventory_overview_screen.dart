// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class StoreInventoryOverviewScreen extends ConsumerStatefulWidget {
  const StoreInventoryOverviewScreen({super.key, required this.store});

  final StoreModel store;

  @override
  ConsumerState<StoreInventoryOverviewScreen> createState() =>
      _StoreInventoryOverviewScreenState();
}

class _StoreInventoryOverviewScreenState
    extends ConsumerState<StoreInventoryOverviewScreen> {
  final searchC = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(storeVmodel)
          .getStoreInventoryOverview(id: widget.store.id ?? '');
    });
  }

  @override
  void dispose() {
    searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final storeVm = ref.watch(storeVmodel);
    return Scaffold(
      appBar: CustomAppbar(
        title: "View Store",
      ),
      body: LoadableContentBuilder(
          isBusy: storeVm.isBusy,
          isError: storeVm.hasError,
          loadingBuilder: (p0) {
            return SizerLoader(
              height: double.infinity,
            );
          },
          errorBuilder: (ctx) {
            return ErrorState(
              message: "Failed to load store sales overview",
              onPressed: () {
                ref
                    .read(storeVmodel)
                    .getStoreSalesOverview(id: widget.store.id ?? '');
              },
            );
          },
          contentBuilder: (context) {
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
                      FilterHeader(
                        title: "Store Product/inventory List",
                        subTitle: "See details of the selected subscription",
                        onFilter: () {},
                      ),
                      YBox(24),
                      Container(
                        width: double.infinity,
                        height: Sizer.height(196),
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
                              title: "TOTAL PRODUCT VALUE",
                              value: storeVm.storeInventoryModel?.totalProducts
                                      .toString() ??
                                  '0',
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: ProductColText(
                                    textColor: colorScheme.black85,
                                    title: "Total Products",
                                    value: storeVm
                                            .storeInventoryModel?.totalProducts
                                            .toString() ??
                                        '0',
                                    valueTextSize: 12,
                                    valueColor: AppColors.primaryBlue,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: ProductColText(
                                    textColor: colorScheme.black85,
                                    title: "Available",
                                    value: storeVm
                                            .storeOverviewModel?.totalSales
                                            .toString() ??
                                        '0',
                                    valueTextSize: 12,
                                    valueColor: AppColors.green1A,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: ProductColText(
                                    textColor: colorScheme.black85,
                                    title: "Low Stock",
                                    value: storeVm
                                            .storeOverviewModel?.processing
                                            .toString() ??
                                        '0',
                                    valueTextSize: 12,
                                    valueColor: AppColors.yellow06,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: ProductColText(
                                    textColor: colorScheme.black85,
                                    title: "Out of stock",
                                    value: storeVm.storeOverviewModel?.cancelled
                                            .toString() ??
                                        '0',
                                    valueTextSize: 12,
                                    valueColor: AppColors.red2D,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      YBox(24),
                      CustomTextField(
                        controller: searchC,
                        isRequired: false,
                        showLabelHeader: false,
                        hintText: "Search with order no.",
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
                      Builder(builder: (context) {
                        if (storeVm
                                .storeInventoryModel?.products?.data?.isEmpty ??
                            true) {
                          return SizedBox(
                            height: Sizer.height(300),
                            child: EmptyListState(
                              text: "No Data",
                            ),
                          );
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(
                            top: Sizer.height(14),
                            bottom: Sizer.height(50),
                          ),
                          itemCount: storeVm.storeInventoryModel?.products?.data
                                  ?.length ??
                              0,
                          separatorBuilder: (_, __) =>
                              HDivider(verticalPadding: 12),
                          itemBuilder: (ctx, i) {
                            final product =
                                storeVm.storeInventoryModel?.products?.data?[i];
                            return InventoryListTile(
                              productImage: product?.primaryMediaUrl ??
                                  AppUtils.dummyImage,
                              productTitle: product?.name ?? "",
                              subTitle: "SKU: ${product?.sku ?? ""}",
                              status: product?.status ?? "",
                              date: AppUtils.dayWithSuffixMonthAndYear(
                                (DateTime.tryParse(product?.dateAdded ?? "") ??
                                        DateTime.now())
                                    .toLocal(),
                              ),
                              onTap: () {},
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
