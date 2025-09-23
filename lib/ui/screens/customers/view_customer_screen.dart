// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ViewCustomerScreen extends ConsumerStatefulWidget {
  const ViewCustomerScreen({super.key, required this.customer});

  final CustomerData customer;

  @override
  ConsumerState<ViewCustomerScreen> createState() => _ViewCustomerScreenState();
}

class _ViewCustomerScreenState extends ConsumerState<ViewCustomerScreen> {
  CustomerDetailsType currentTab = CustomerDetailsType.basicInfo;

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppbar(
        title: "View Customer",
      ),
      body: Column(
        children: [
          YBox(16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                XBox(20),
                NotificationTab(
                  text: "Basic information",
                  isSelected: currentTab == CustomerDetailsType.basicInfo,
                  onTap: () {
                    currentTab = CustomerDetailsType.basicInfo;
                    setState(() {});
                  },
                ),
                XBox(6),
                NotificationTab(
                  text: "Orders",
                  isSelected: currentTab == CustomerDetailsType.orders,
                  onTap: () {
                    currentTab = CustomerDetailsType.orders;
                    setState(() {});
                  },
                ),
                XBox(6),
                NotificationTab(
                  text: "Returns",
                  isSelected: currentTab == CustomerDetailsType.returns,
                  onTap: () {
                    currentTab = CustomerDetailsType.returns;
                    setState(() {});
                  },
                ),
                XBox(6),
                NotificationTab(
                  text: "Reviews",
                  isSelected: currentTab == CustomerDetailsType.reviews,
                  onTap: () {
                    currentTab = CustomerDetailsType.reviews;
                    setState(() {});
                  },
                ),
                // XBox(6),
                // NotificationTab(
                //   text: "Payment Method",
                //   isSelected: indexStack == 4,
                //   onTap: () {
                //     indexStack = 4;
                //     setState(() {});
                //   },
                // ),
                XBox(30),
              ],
            ),
          ),
          YBox(16),
          switch (currentTab) {
            CustomerDetailsType.basicInfo =>
              BasicInfoTab(customer: widget.customer),
            CustomerDetailsType.orders =>
              CustomerOrdersTab(customer: widget.customer),
            CustomerDetailsType.returns =>
              CustomerReturnsTab(customer: widget.customer),
            CustomerDetailsType.reviews =>
              CustomerReviewsTab(customer: widget.customer),
            // CustomerDetailsType.paymentMethods => CustomersPaymentMethodTab(customer: widget.customer),
          },
        ],
      ),
    );
  }
}
