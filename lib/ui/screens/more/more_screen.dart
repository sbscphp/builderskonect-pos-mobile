import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class MoreMenu {
  final String title;
  final String icon;
  final String? routePath;

  MoreMenu({
    required this.title,
    required this.icon,
    this.routePath,
  });
}

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MoreScreenState();
}

class _MoreScreenState extends ConsumerState<MoreScreen> {
  List<MoreMenu> moremenus = [
    MoreMenu(
      title: "Vendor Profile",
      icon: AppSvgs.product,
      routePath: RoutePath.profileScreen,
    ),
    MoreMenu(
      title: "Customers",
      icon: AppSvgs.product,
    ),
    MoreMenu(
      title: "Returns and Refund",
      icon: AppSvgs.product,
      routePath: RoutePath.returnRefundScreen,
    ),
    MoreMenu(
      title: "Discounts",
      icon: AppSvgs.product,
    ),
    MoreMenu(
      title: "Staff Management",
      icon: AppSvgs.product,
    ),
    MoreMenu(
      title: "Settings",
      icon: AppSvgs.product,
      routePath: RoutePath.settingScreen,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppbar(
        title: "Profile",
        leadingWidget: SizedBox.shrink(),
      ),
      body: ListView.separated(
        shrinkWrap: true,
        itemCount: moremenus.length,
        padding: EdgeInsets.only(
          left: Sizer.width(16),
          right: Sizer.width(16),
          top: Sizer.height(16),
          bottom: Sizer.height(50),
        ),
        separatorBuilder: (_, __) => YBox(16),
        itemBuilder: (_, i) {
          return InkWell(
            onTap: () {
              if (moremenus[i].routePath != null) {
                Navigator.pushNamed(context, moremenus[i].routePath!);
              }
            },
            child: MenuCard(
              title: moremenus[i].title,
              icon: moremenus[i].icon,
            ),
          );
        },
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  const MenuCard({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  final String title;
  final String icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Sizer.radius(16)),
        decoration: BoxDecoration(color: colorScheme.white),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Sizer.width(12),
                vertical: Sizer.height(10),
              ),
              decoration: BoxDecoration(
                color: AppColors.dayBreakBlue,
                borderRadius: BorderRadius.circular(Sizer.radius(4)),
              ),
              child: SvgPicture.asset(
                icon,
                height: Sizer.height(24),
              ),
            ),
            XBox(8),
            Text(
              title,
              style: textTheme.text16,
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: Sizer.height(16),
            )
          ],
        ),
      ),
    );
  }
}
