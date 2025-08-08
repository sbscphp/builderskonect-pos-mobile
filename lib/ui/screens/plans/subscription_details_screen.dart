// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class SubscriptionDetailsScreen extends ConsumerStatefulWidget {
  const SubscriptionDetailsScreen({super.key, required this.arg});

  final UserSubcription arg;

  @override
  ConsumerState<SubscriptionDetailsScreen> createState() =>
      _SubscriptionDetailsScreenState();
}

class _SubscriptionDetailsScreenState
    extends ConsumerState<SubscriptionDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BusyOverlay(
      show: ref.watch(subscriptionVModel).isBusy,
      child: Scaffold(
        appBar: CustomAppbar(
          title: "View Subscription",
        ),
        body: ListView(
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
                    title: "Subscription Details",
                    subTitle: "See details of the selected subscription",
                    svgIcon: AppSvgs.circleMenu,
                    onFilter: () {
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(100, 100, 0, 0),
                        items: [
                          PopupMenuItem(
                            value: 'renew',
                            child: Text('Renew Subscription',
                                style: textTheme.text14),
                          ),
                          PopupMenuItem(
                            value: 'change',
                            child: Text('Change Subscription',
                                style: textTheme.text14),
                          ),
                          PopupMenuItem(
                            value: 'cancel',
                            child: Text(
                              'Cancel Subscription',
                              style: textTheme.text14?.copyWith(
                                color: AppColors.red2D,
                              ),
                            ),
                          ),
                        ],
                      ).then((value) {
                        // Handle the selected option
                        if (value != null) {
                          // Implement the action for the selected option
                          printty('Selected: $value');
                          switch (value) {
                            case 'renew':
                              Navigator.pushNamed(
                                  context, RoutePath.renewSubscriptionScreen);
                              break;
                            case 'change':
                              Navigator.pushNamed(
                                context,
                                RoutePath.pricingPlansScreen,
                                arguments: true,
                              );
                              break;
                            case 'cancel':
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
                                              .cancelSubscription(
                                                  widget.arg.id ?? "");
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
                              break;
                            default:
                              break;
                          }
                        }
                      });
                    },
                  ),
                  YBox(24),
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
                          title: "Invoice ID",
                          subTitle: widget.arg.paymentReference ?? "N/A",
                        ),
                        YBox(16),
                        ProfileColText(
                          title: "Subscription Plan",
                          subTitle: widget.arg.planName ?? "N/A",
                        ),
                        YBox(16),
                        ProfileColText(
                          title: "Amount",
                          subTitle: widget.arg.amountPaid ?? "N/A",
                        ),
                        YBox(16),
                        ProfileColText(
                          title: "Date Subscribed",
                          subTitle: widget.arg.subscribedAt == null
                              ? "N/A"
                              : AppUtils.dayWithSuffixMonthAndYear(
                                  widget.arg.subscribedAt ?? DateTime.now()),
                        ),
                        YBox(16),
                        ProfileColText(
                          title: "Expiring Date",
                          subTitle: widget.arg.endDate == null
                              ? "N/A"
                              : AppUtils.dayWithSuffixMonthAndYear(
                                  widget.arg.endDate ?? DateTime.now()),
                        ),
                        YBox(16),
                        Text(
                          "Status",
                          style: textTheme.text12?.copyWith(
                            color: AppColors.grey175,
                          ),
                        ),
                        YBox(4),
                        OrderStatus(
                          status: widget.arg.status ?? "N/A",
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                    title: "Payment Details",
                    subTitle:
                        "See details of the payment for this subscription",
                  ),
                  YBox(24),
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
                          title: "Transaction ID",
                          subTitle: widget.arg.paymentReference ?? "N/A",
                          onCopy: () {},
                        ),
                        YBox(16),
                        ProfileColText(
                          title: "Transaction Date",
                          subTitle: widget.arg.paymentDate == null
                              ? "N/A"
                              : AppUtils.dayWithSuffixMonthAndYear(
                                  widget.arg.paymentDate ?? DateTime.now()),
                        ),
                        YBox(16),
                        ProfileColText(
                          title: "Payment Method",
                          subTitle: widget.arg.paymentMethod ?? "N/A",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
