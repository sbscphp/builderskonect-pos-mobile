// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class StoreSalesOverviewScreen extends ConsumerStatefulWidget {
  const StoreSalesOverviewScreen({super.key, required this.store});

  final StoreModel store;

  @override
  ConsumerState<StoreSalesOverviewScreen> createState() =>
      _StoreSalesOverviewScreenState();
}

class _StoreSalesOverviewScreenState
    extends ConsumerState<StoreSalesOverviewScreen> {
  final searchC = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(storeVmodel).getStoreSalesOverview(id: widget.store.id ?? '');
    });
  }

  @override
  void dispose() {
    searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
                        title: "Sales Overview",
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
                              title: "TOTAL SALES VALUE",
                              value: AppUtils.formatNumber(
                                decimalPlaces: 2,
                                number: storeVm
                                        .storeOverviewModel?.totalSalesValue ??
                                    0,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: ProductColText(
                                    textColor: colorScheme.black85,
                                    title: "Total Sales",
                                    value: AppUtils.formatNumber(
                                      decimalPlaces: 2,
                                      number: storeVm
                                              .storeOverviewModel?.totalSales ??
                                          0,
                                    ),
                                    valueTextSize: 12,
                                    valueColor: AppColors.primaryBlue,
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: ProductColText(
                                    textColor: colorScheme.black85,
                                    title: "Completed Sales",
                                    value: storeVm.storeOverviewModel?.completed
                                            .toString() ??
                                        '0',
                                    valueTextSize: 12,
                                    valueColor: AppColors.green1A,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: ProductColText(
                                    textColor: colorScheme.black85,
                                    title: "Processing Sales",
                                    value: storeVm
                                            .storeOverviewModel?.processing
                                            .toString() ??
                                        '0',
                                    valueTextSize: 12,
                                    valueColor: AppColors.primaryBlue,
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: ProductColText(
                                    textColor: colorScheme.black85,
                                    title: "Cancelled Sales",
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
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: Sizer.height(14),
                          bottom: Sizer.height(50),
                        ),
                        itemCount: storeVm.storeOverviewModel?.salesOverview
                                ?.data?.length ??
                            0,
                        separatorBuilder: (_, __) => HDivider(),
                        itemBuilder: (ctx, i) {
                          final sales = storeVm
                              .storeOverviewModel?.salesOverview?.data?[i];
                          return CustomColWidget(
                            firstColText: sales?.orderNumber ?? '',
                            subTitle: "Total itmes: ",
                            subTitle2: "${sales?.itemsCount ?? 0}",
                            status: sales?.status ?? '',
                            date: sales?.date?.toLocal(),
                            onTap: () {},
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
