import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class PricingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String price;
  final String period;
  final VoidCallback onSubscribe;
  final VoidCallback onLearnMore;

  const PricingCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.price,
    required this.period,
    required this.onSubscribe,
    required this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Sizer.radius(16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(
        //   color: AppColors.dayBreakBlue3,
        //   width: 2,
        // ),
        image: const DecorationImage(
          image: AssetImage(AppImages.planCard),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Title
          Row(
            children: [
              SvgPicture.asset(AppSvgs.pentagon),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.text16.bold,
                    ),
                    YBox(4),
                    Text(
                      description,
                      style: AppTypography.text12.withCustomColor(
                        AppColors.black.withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          YBox(20),
          Row(
            children: [
              Text(
                price,
                style: AppTypography.text20.medium,
              ),
              const SizedBox(width: 4),
              Text(
                period,
                style: AppTypography.text12.withCustomColor(
                  AppColors.black.withValues(alpha: 0.45),
                ),
              ),
            ],
          ),
          YBox(20),
          CustomBtn.solid(
            text: 'Subscribe Now',
            onTap: onSubscribe,
          ),
          YBox(20),
          Center(
            child: InkWell(
              onTap: onLearnMore,
              child: Text('Learn more about this plan',
                  style: AppTypography.text14
                      .withCustomColor(AppColors.primaryBlue)),
            ),
          ),
        ],
      ),
    );
  }
}
