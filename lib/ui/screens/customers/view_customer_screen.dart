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
  int indexStack = 0;

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
                  isSelected: indexStack == 0,
                  onTap: () {
                    indexStack = 0;
                    setState(() {});
                  },
                ),
                XBox(6),
                NotificationTab(
                  text: "Orders",
                  isSelected: indexStack == 1,
                  onTap: () {
                    indexStack = 1;
                    setState(() {});
                  },
                ),
                XBox(6),
                NotificationTab(
                  text: "Returns",
                  isSelected: indexStack == 2,
                  onTap: () {
                    indexStack = 2;
                    setState(() {});
                  },
                ),
                XBox(6),
                NotificationTab(
                  text: "Reviews",
                  isSelected: indexStack == 3,
                  onTap: () {
                    indexStack = 3;
                    setState(() {});
                  },
                ),
                XBox(6),
                NotificationTab(
                  text: "Payment Method",
                  isSelected: indexStack == 4,
                  onTap: () {
                    indexStack = 4;
                    setState(() {});
                  },
                ),
                XBox(30),
              ],
            ),
          ),
          YBox(16),
          Expanded(
            child: IndexedStack(
              index: indexStack,
              children: [
                BasicInfoTab(customer: widget.customer),
                CustomerOrdersTab(),
                CustomerReturnsTab(),
                CustomerReviewsTab(),
                CustomersPaymentMethodTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
