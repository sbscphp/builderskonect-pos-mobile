import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class VendorReviewsTab extends ConsumerStatefulWidget {
  const VendorReviewsTab({super.key});

  @override
  VendorReviewsTabState createState() => VendorReviewsTabState();
}

class VendorReviewsTabState extends ConsumerState<VendorReviewsTab> {
  final searchC = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(customerVmodel).vendorReviewProduct();
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
    final customerVm = ref.read(customerVmodel);
    return Expanded(
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
            child: Builder(builder: (context) {
              if (customerVm.busy(viewState)) {
                return SizerLoader(height: 600);
              }
              if (customerVm.error(viewState)) {
                return SizedBox(
                  height: Sizer.height(600),
                  child: Center(
                    child: ErrorState(
                      onPressed: () {
                        ref
                            .read(productInventoryVmodel)
                            .getInventoryProducts(productReview: true);
                      },
                    ),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilterHeader(
                    title: "Vendor Reviews",
                    subTitle: "View and manage vendor reviews here",
                  ),
                  YBox(16),
                  Container(
                    width: double.infinity,
                    height: Sizer.height(260),
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
                          title: "TOTAL REVIEWS",
                          value: AppUtils.formatNumber(
                              number:
                                  customerVm.vendorReviewsStats?.total ?? 0),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: ProductColText(
                                textColor: colorScheme.black85,
                                title: "5 Stars",
                                value: AppUtils.formatNumber(
                                    number:
                                        customerVm.vendorReviewsStats?.five ??
                                            0),
                                valueTextSize: Sizer.text(12),
                                valueColor: AppColors.green7,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: ProductColText(
                                textColor: colorScheme.black85,
                                title: "4 Stars",
                                value: AppUtils.formatNumber(
                                    number:
                                        customerVm.vendorReviewsStats?.four ??
                                            0),
                                valueTextSize: Sizer.text(12),
                                valueColor: AppColors.red2D,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: ProductColText(
                                textColor: colorScheme.black85,
                                title: "3 Stars",
                                value: AppUtils.formatNumber(
                                    number:
                                        customerVm.vendorReviewsStats?.three ??
                                            0),
                                valueTextSize: Sizer.text(12),
                                valueColor: AppColors.green7,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: ProductColText(
                                textColor: colorScheme.black85,
                                title: "2 Stars",
                                value: AppUtils.formatNumber(
                                    number:
                                        customerVm.vendorReviewsStats?.two ??
                                            0),
                                valueTextSize: Sizer.text(12),
                                valueColor: AppColors.red2D,
                              ),
                            ),
                          ],
                        ),
                        ProductColText(
                          textColor: colorScheme.black85,
                          title: "1 Stars",
                          value: AppUtils.formatNumber(
                              number: customerVm.vendorReviewsStats?.one ?? 0),
                          valueTextSize: Sizer.text(12),
                          valueColor: AppColors.green7,
                        ),
                      ],
                    ),
                  ),
                  YBox(24),
                  CustomTextField(
                    controller: searchC,
                    isRequired: false,
                    showLabelHeader: false,
                    hintText: "Search by product id, name etc.",
                    onChanged: (value) {
                      setState(() {});
                    },
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(Sizer.width(14)),
                            decoration: BoxDecoration(
                                border: Border(
                              left: BorderSide(
                                color: AppColors.neutral5,
                                width: 1,
                              ),
                            )),
                            child: SvgPicture.asset(AppSvgs.search),
                          ),
                        ),
                      ],
                    ),
                  ),
                  YBox(10),
                  LoadableContentBuilder(
                    isBusy: customerVm.busy(vendorReviewsState),
                    isError: customerVm.error(vendorReviewsState),
                    items: customerVm.vendorReviewModel,
                    loadingBuilder: (p0) {
                      return SizedBox.shrink();
                    },
                    emptyBuilder: (context) {
                      return SizedBox(
                        height: Sizer.height(250),
                        child: EmptyListState(
                          text: "No Data",
                        ),
                      );
                    },
                    contentBuilder: (context) {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: Sizer.height(14),
                        ),
                        itemCount: customerVm.vendorReviewModel.length,
                        separatorBuilder: (_, __) => HDivider(),
                        itemBuilder: (ctx, i) {
                          final c = customerVm.vendorReviewModel[i];
                          return CustomerReviewListTile(
                            image: "",
                            leadWidget: SvgPicture.asset(
                              AppSvgs.circleAvatar,
                              height: Sizer.height(24),
                            ),
                            title: c.customerName ?? "",
                            subTitle: "Id: ",
                            subTitle2: c.customerId ?? "N/A",
                            rating: double.tryParse(
                              c.ratings ?? "0",
                            ),
                            date: AppUtils.dayWithSuffixMonthAndYear(
                              DateTime.now(),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RoutePath.vendorReviewDetailsScreen,
                                arguments: c,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
