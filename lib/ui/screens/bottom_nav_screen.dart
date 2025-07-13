import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:builders_konnect/ui/screens/screens.dart';

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

  List<Map<String, Object>> screensMap = [
    {
      "name": "Point of Sales",
      "screen": const PosScreen(),
      "iconPath": AppSvgs.pos,
    },
    {
      "name": "Accounting",
      "screen": const AccountingScreen(),
      "iconPath": AppSvgs.accounting,
    },
    {
      "name": "Procurement",
      "screen": const ProcurementScreen(),
      "iconPath": AppSvgs.procurement,
    },
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
          body: screensMap[currentIndex]["screen"] as Widget,
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
                ...screensMap.map((e) {
                  final index = screensMap.indexOf(e);
                  return BottomNavColumn(
                    icon: e["iconPath"],
                    isActive: currentIndex == index,
                    labelText: e["name"] as String,
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
