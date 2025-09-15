// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class AddProductRequestScreen extends ConsumerStatefulWidget {
  const AddProductRequestScreen({super.key});

  @override
  ConsumerState<AddProductRequestScreen> createState() =>
      _AddProductRequestScreenState();
}

class _AddProductRequestScreenState
    extends ConsumerState<AddProductRequestScreen> {
  int regSteps = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppbar(
        title: "Request to Add Product",
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(Sizer.radius(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RegSteps(
                  number: "1",
                  text: "Basic Info",
                  isActive: regSteps == 1,
                  passed: regSteps > 1,
                ),
                XBox(6),
                RegSteps(
                  number: "2",
                  text: "Attributes & Variants",
                  isActive: regSteps == 2,
                  passed: regSteps > 2,
                ),
                XBox(6),
                RegSteps(
                  number: "3",
                  text: "Other Info",
                  isActive: regSteps == 3,
                  passed: regSteps > 3,
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
                1 => RequestBasicInfo(
                    key: const ValueKey('basic_info'),
                    onNext: () {
                      regSteps = 2;
                      setState(() {});
                    },
                  ),
                2 => RequestAttributeVarientTab(
                    key: const ValueKey('attribute_varient'),
                    onNext: () {
                      regSteps = 3;
                      setState(() {});
                    },
                    onPrevious: () {
                      regSteps = 1;
                      setState(() {});
                    },
                  ),
                _ => RequestOtherInfoTab(
                    key: const ValueKey('other_info'),
                    onPrevious: () {
                      setState(() {
                        regSteps = 2;
                      });
                    },
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
