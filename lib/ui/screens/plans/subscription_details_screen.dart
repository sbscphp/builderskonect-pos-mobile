// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class SubscriptionDetailsScreen extends ConsumerStatefulWidget {
  const SubscriptionDetailsScreen({super.key});

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
    return Scaffold(
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
                          child: Text('Cancel Subscription',
                              style: textTheme.text14?.copyWith(
                                color: AppColors.red2D,
                              )),
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
                                context, RoutePath.renewSubscriptionScreen);
                            break;
                          case 'cancel':
                            Navigator.pushNamed(
                                context, RoutePath.renewSubscriptionScreen);
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
                        subTitle: "689937",
                      ),
                      YBox(16),
                      ProfileColText(
                        title: "Subscription Plan",
                        subTitle: "Basic Monthly",
                      ),
                      YBox(16),
                      ProfileColText(
                        title: "Amount",
                        subTitle: "N 3000",
                      ),
                      YBox(16),
                      ProfileColText(
                        title: "Date Subscribed",
                        subTitle: "25 Jan, 2025",
                      ),
                      YBox(16),
                      ProfileColText(
                        title: "Expiring Date",
                        subTitle: "25 Jan, 2025",
                      ),
                      YBox(16),
                      ProfileColText(
                        title: "Business address",
                        subTitle: "123 Main St, Anytown, USA",
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
                        status: 'Active',
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
                  subTitle: "See details of the payment for this subscription",
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
                        subTitle: "689937",
                        onCopy: () {},
                      ),
                      YBox(16),
                      ProfileColText(
                        title: "Transaction Date",
                        subTitle: "Basic Monthly",
                      ),
                      YBox(16),
                      ProfileColText(
                        title: "Payment Method",
                        subTitle: "buildershub@gmail.com",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
