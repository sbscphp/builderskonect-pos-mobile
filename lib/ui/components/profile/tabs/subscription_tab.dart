import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class SubscriptionTab extends ConsumerStatefulWidget {
  const SubscriptionTab({super.key});

  @override
  ConsumerState<SubscriptionTab> createState() => _SubscriptionTabState();
}

class _SubscriptionTabState extends ConsumerState<SubscriptionTab> {
  final searchC = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subscriptionVModel).getSubcriptionHistory();
    });
  }

  @override
  void dispose() {
    searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final subscriptionVm = ref.watch(subscriptionVModel);
    return LoadableContentBuilder(
        isBusy: subscriptionVm.isBusy,
        loadingBuilder: (ctx) {
          return SizerLoader(
            height: double.infinity,
          );
        },
        emptyBuilder: (ctx) {
          return Center(
            child: Text(
              "No Data",
              style: textTheme.text14?.medium.copyWith(
                color: AppColors.gray500,
              ),
            ),
          );
        },
        contentBuilder: (ctx) {
          return RefreshIndicator(
            onRefresh: () async {
              subscriptionVm.getSubcriptionHistory();
            },
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
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
                      Container(
                        padding: EdgeInsets.all(Sizer.radius(16)),
                        decoration: BoxDecoration(
                          color: AppColors.dayBreakBlue,
                          borderRadius: BorderRadius.circular(Sizer.radius(8)),
                          border: Border.all(
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subscriptionVm
                                            .currentSubscription?.planName ??
                                        "",
                                    style: textTheme.text12?.copyWith(
                                      color: AppColors.gray600,
                                    ),
                                  ),
                                  YBox(4),
                                  Text(
                                    subscriptionVm
                                            .currentSubscription?.amountPaid ??
                                        "",
                                    style: textTheme.text24?.medium.copyWith(
                                      color: colorScheme.primaryColor,
                                    ),
                                  ),
                                  YBox(4),
                                  Text(
                                    "Expires: ${AppUtils.dayWithSuffixMonthAndYear(subscriptionVm.currentSubscription?.endDate ?? DateTime.now())}",
                                    style: textTheme.text12?.copyWith(
                                      color: AppColors.gray500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            OrderStatus(
                              status:
                                  subscriptionVm.currentSubscription?.status ??
                                      "",
                            )
                          ],
                        ),
                      ),
                      YBox(16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomBtn(
                              text: "Renew",
                              isOutline: true,
                              textColor: colorScheme.black85,
                              height: 40,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RoutePath.renewSubscriptionScreen,
                                    arguments:
                                        subscriptionVm.currentSubscription);
                              },
                            ),
                          ),
                          XBox(8),
                          Expanded(
                            child: CustomBtn(
                              text: "Upgrade",
                              isOutline: true,
                              textColor: colorScheme.black85,
                              height: 40,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  RoutePath.pricingPlansScreen,
                                  arguments: true,
                                );
                              },
                            ),
                          ),
                          XBox(8),
                          Expanded(
                            child: CustomBtn(
                              text: "Cancel",
                              isOutline: true,
                              textColor: AppColors.red2D,
                              height: 40,
                              onTap: () {
                                final loadingProvider =
                                    StateProvider<bool>((ref) => false);
                                ModalWrapper.bottomSheet(
                                  context: context,
                                  widget:
                                      Consumer(builder: (context, ref, child) {
                                    final isLoading = ref.watch(loadingProvider);
                                    return ConfirmationModal(
                                      modalConfirmationArg: ModalConfirmationArg(
                                        iconPath: AppSvgs.infoCircleRed,
                                        title: "Cancel Subscription",
                                        description:
                                            "Are you sure you want to cancel subscription? Once cancelled you will no longer be able to see features on this plan",
                                        solidBtnText: "Yes, cancel",
                                        outlineBtnText: "No, don’t",
                                        isLoading: isLoading,
                                        onSolidBtnOnTap: () async {
                                          // Set loading to true
                                          ref
                                              .read(loadingProvider.notifier)
                                              .state = true;
                                          try {
                                            await ref
                                                .read(subscriptionVModel)
                                                .cancelSubscription(subscriptionVm
                                                    .subscriptionHistory[0].id!);
                                          } finally {
                                            // Check if the widget is still mounted before using ref
                                            if (context.mounted) {
                                              ref
                                                  .read(loadingProvider.notifier)
                                                  .state = false;
                                            }
                                          }
                                        },
                                        onOutlineBtnOnTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  }),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      YBox(16),
                      HLine(),
                      YBox(16),
                      FilterHeader(
                        title: "Billing History",
                        subTitle:
                            "This shows the vendors billing history overtime",
                        onFilter: () {
                           ModalWrapper.bottomSheet(
                          context: context,
                          widget: FilterDataModal(
                            selectorGroups: [
                              SelectorGroup(
                                key: "status",
                                title: "Status",
                                options: [
                                  "All status",
                                  "Active",
                                  "Expired",
                                  "Cancelled",
                                ],
                                // selectedValue: "Completed",
                              ),
                            ],
                            onFilter: (filterData) {
                              printty("Filter applied: $filterData");
                            },
                            onReset: () {
                              printty("Filters reset");
                              // Handle reset action here
                            },
                          ));
                        },
                      ),
                      YBox(16),
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
                        itemCount: subscriptionVm.subscriptionHistory.length,
                        separatorBuilder: (_, __) => HDivider(),
                        itemBuilder: (ctx, i) {
                          final item = subscriptionVm.subscriptionHistory[i];
                          return CustomColWidget(
                            firstColText: item.planName ?? "",
                            subTitle: item.amountPaid ?? "",
                            status: item.status ?? "",
                            date: item.endDate ?? DateTime.now(),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RoutePath.subscriptionDetailsScreen,
                                arguments: item,
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
        });
  }
}
