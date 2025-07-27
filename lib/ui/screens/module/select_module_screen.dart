import 'package:builders_konnect/core/core.dart';

class SelectModuleScreen extends StatelessWidget {
  const SelectModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        backgroundColor: colorScheme.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(Sizer.height(60)),
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: Sizer.width(16),
              right: Sizer.width(16),
              bottom: Sizer.height(6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select Module", style: textTheme.text16?.medium),
                Text(
                  "Select the module you want to view now.",
                  style: textTheme.text14?.copyWith(
                    color: colorScheme.black45,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.only(
            top: Sizer.height(24),
            left: Sizer.width(16),
            right: Sizer.width(16),
          ),
          children: [
            ModuleCard(
              title: "Point of sales",
              subTitle:
                  "Dashboard, sales, products, inventory, customer management, discounts, returns and refund etc",
              iconPath: AppSvgs.pos,
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, RoutePath.bottomNavScreen);
              },
            ),
            YBox(24),
            ModuleCard(
              title: "Accounting",
              subTitle:
                  "Dashboard, sales, products, inventory, customer management, discounts, returns and refund etc.",
              iconPath: AppSvgs.accounting,
            ),
            YBox(24),
            ModuleCard(
              title: "Procurement",
              subTitle:
                  "Dashboard, sales, products, inventory, customer management, discounts, returns and refund etc",
              iconPath: AppSvgs.procurement,
            ),
            YBox(24),
            ModuleCard(
              title: "Reports",
              subTitle:
                  "Dashboard, sales, products, inventory, customer management, discounts, returns and refund etc",
              iconPath: AppSvgs.pos,
            ),
            YBox(24),
          ],
        ));
  }
}

class ModuleCard extends StatelessWidget {
  const ModuleCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.iconPath,
    this.onTap,
  });

  final String title;
  final String subTitle;
  final String iconPath;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Sizer.width(16),
          vertical: Sizer.height(10),
        ),
        decoration: BoxDecoration(
          color: AppColors.dayBreakBlue,
          borderRadius: BorderRadius.circular(Sizer.radius(4)),
          border: Border.all(
            color: AppColors.dayBreakBlue3,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(iconPath),
            YBox(16),
            Text(title, style: textTheme.text14),
            YBox(4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    subTitle,
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                ),
                XBox(10),
                Icon(
                  Icons.arrow_forward_ios,
                  size: Sizer.radius(16),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
