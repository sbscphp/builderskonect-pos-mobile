// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class DiscountManagementScreen extends ConsumerStatefulWidget {
  const DiscountManagementScreen({super.key});

  @override
  ConsumerState<DiscountManagementScreen> createState() =>
      _DiscountManagementScreenState();
}

class _DiscountManagementScreenState
    extends ConsumerState<DiscountManagementScreen> {
  final searchC = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(storeVmodel).getStoreSalesOverview(id: widget.store.id ?? '');
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
        title: "Discount Management",
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
              onPressed: () {},
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
                        title: "Discounts Overview",
                        subTitle: "View and manage all discounts created",
                        trailingWidget: NewButtonWidget(
                          onTap: () {
                            // Navigator.pushNamed(
                            //     context, RoutePath.newStaffScreen);
                          },
                        ),
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
                              title: "TOTAL DISCOUNTS",
                              value: AppUtils.formatNumber(
                                number: 0,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: ProductColText(
                                    textColor: colorScheme.black85,
                                    title: "Total Active",
                                    value: AppUtils.formatNumber(
                                      number: 0,
                                    ),
                                    valueTextSize: 12,
                                    valueColor: AppColors.primaryBlue,
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: ProductColText(
                                    textColor: colorScheme.black85,
                                    title: "Total Expired",
                                    value: "0",
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
                                    title: "Total Scheduled",
                                    value: '0',
                                    valueTextSize: 12,
                                    valueColor: AppColors.primaryBlue,
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: ProductColText(
                                    textColor: colorScheme.black85,
                                    title: "Redemption",
                                    value: '0',
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
                      FilterHeader(
                        title: "Discount List",
                        subTitle: "See all discounts created",
                        onFilter: () async {},
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: searchC,
                        isRequired: false,
                        showLabelHeader: false,
                        hintText: "Search by product id, name etc",
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
                        itemCount: 6,
                        separatorBuilder: (_, __) => HDivider(),
                        itemBuilder: (ctx, i) {
                          return DiscountListTile(
                            title: "Christmas Coupon",
                            code: "SBSCXSANTA",
                            amount: "N 1,000",
                            type: "Amount off",
                            status: "Active",
                            date: DateTime.now(),
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
