// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ReviewsAndFeedbackScreen extends ConsumerStatefulWidget {
  const ReviewsAndFeedbackScreen({super.key});

  @override
  ConsumerState<ReviewsAndFeedbackScreen> createState() =>
      _ReviewsAndFeedbackScreenState();
}

class _ReviewsAndFeedbackScreenState
    extends ConsumerState<ReviewsAndFeedbackScreen> {
  int indexStack = 0;

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppbar(
        title: "Reviews and Feedback",
      ),
      body: Column(
        children: [
          YBox(16),
          Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  XBox(20),
                  NotificationTab(
                    text: "Product Reviews",
                    isSelected: indexStack == 0,
                    onTap: () {
                      indexStack = 0;
                      setState(() {});
                    },
                  ),
                  XBox(6),
                  NotificationTab(
                    text: "Vendor Reviews",
                    isSelected: indexStack == 1,
                    onTap: () {
                      indexStack = 1;
                      setState(() {});
                    },
                  ),
                  XBox(30),
                ],
              ),
            ),
          ),
          YBox(16),
          Expanded(
            child: IndexedStack(
              index: indexStack,
              children: [
                ProductReviewsTab(),
                VendorReviewsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
