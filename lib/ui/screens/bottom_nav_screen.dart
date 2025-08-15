import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:builders_konnect/ui/screens/screens.dart';

class DashboardNav {
  final String name;
  final String iconPath;
  final Widget screen;
  final Function()? onTap;

  DashboardNav({
    required this.name,
    required this.iconPath,
    required this.screen,
    this.onTap,
  });
}

class BottomNavScreen extends ConsumerStatefulWidget {
  const BottomNavScreen({
    super.key,
    this.args,
  });

  final DashArg? args;

  @override
  ConsumerState<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends ConsumerState<BottomNavScreen> {
  int currentIndex = 0;

  List<DashboardNav> items = [
    DashboardNav(
      name: "Dashboard",
      iconPath: AppSvgs.dashboard,
      screen: const PosScreen(),
    ),
    DashboardNav(
      name: "Products",
      iconPath: AppSvgs.product,
      screen: const ProductScreen(),
    ),
    DashboardNav(
      name: "Sales",
      iconPath: AppSvgs.bag,
      screen: const SalesScreen(),
    ),
    DashboardNav(
      name: "Profile",
      iconPath: AppSvgs.profile,
      screen: const VendorProfileScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.args?.index != null) {
      currentIndex = widget.args!.index!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  _init() async {}

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BusyOverlay(
        show: false,
        child: Scaffold(
          body: items[currentIndex].screen,
          backgroundColor: AppColors.white,
          bottomNavigationBar: Container(
            height: Sizer.height(84),
            padding: EdgeInsets.only(
              bottom: Sizer.height(10),
            ),
            // decoration: BoxDecoration(
            //     color: AppColors.white,
            //     border: Border(
            //       top: BorderSide(
            //         color: AppColors.grayF8,
            //       ),
            //     )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ...items.map((e) {
                  final index = items.indexOf(e);
                  return BottomNavColumn(
                    icon: e.iconPath,
                    isActive: currentIndex == index,
                    labelText: e.name,
                    onPressed: () {
                      currentIndex = index;
                      setState(() {});
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
