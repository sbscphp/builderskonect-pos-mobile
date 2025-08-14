// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class NewSalesScreen extends ConsumerStatefulWidget {
  const NewSalesScreen({super.key});

  @override
  ConsumerState<NewSalesScreen> createState() => _NewSalesScreenState();
}

class _NewSalesScreenState extends ConsumerState<NewSalesScreen> {
  int regSteps = 1;

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: CustomAppbar(
          title: "New Sales",
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: Sizer.width(16),
                horizontal: Sizer.width(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RegSteps(
                    number: "1",
                    text: "Select Products",
                    isActive: regSteps == 1,
                  ),
                  RegSteps(
                    number: "2",
                    text: "Customer Details",
                    isActive: regSteps == 2,
                  ),
                  RegSteps(
                    number: "3",
                    text: "Order Summary",
                    isActive: regSteps == 3,
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: switch (regSteps) {
                  1 => SelectProductsStep(
                      key: const ValueKey('select_products'),
                      onNext: () {
                        regSteps = 2;
                        setState(() {});
                      },
                    ),
                  2 => CustomerDetailsStep(
                      key: const ValueKey('bank_details'),
                      onNext: () {
                        regSteps = 3;
                        setState(() {});
                      },
                    ),
                  _ => OrderSummaryStep(
                      key: const ValueKey('document_upload'),
                    ),
                },
              ),
            ),
          ],
        ));
  }
}
