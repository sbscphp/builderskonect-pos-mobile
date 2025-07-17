import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class PricingPlansScreen extends StatefulWidget {
  const PricingPlansScreen({super.key});

  @override
  State<PricingPlansScreen> createState() => _PricingPlansScreenState();
}

class _PricingPlansScreenState extends State<PricingPlansScreen> {
  bool isYearly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppbar(title: ""),
      body: Padding(
        padding: EdgeInsets.only(
          left: Sizer.width(16),
          right: Sizer.width(16),
          top: Sizer.height(16),
        ),
        child: Column(
          children: [
            Text(
              "Pricing Plans",
              style: Theme.of(context).textTheme.text20?.medium,
            ),
            YBox(16),
            PricingTab(
              isYearly: isYearly,
              onChanged: (value) => setState(() => isYearly = value),
            ),
            YBox(10),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: 2,
                padding: EdgeInsets.only(
                  top: Sizer.height(20),
                  bottom: Sizer.height(50),
                ),
                separatorBuilder: (_, __) => YBox(16),
                itemBuilder: (_, i) {
                  return PricingCard(
                    icon: Icons.home_outlined,
                    title: 'Standard Plan',
                    description:
                        'Essential features for growing building materials vendors',
                    price: '₦ 10,000',
                    period: isYearly ? '/ per year' : '/ per month',
                    onSubscribe: () {
                      Navigator.pushNamed(context, RoutePath.getStartedScreen);
                    },
                    onLearnMore: () {
                      // Handle learn more
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
