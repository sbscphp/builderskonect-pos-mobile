// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;
  late AnimationController _tabController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _tabController,
      curve: Curves.easeInOut,
    ));
    _tabController.forward();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // ref.read(storeVmodel).getStoreOverview();
    });
  }

  void _onTabChanged(int index) {
    if (currentIndex != index) {
      setState(() {
        currentIndex = index;
      });
    }
  }

  Widget _buildTabContent() {
    switch (currentIndex) {
      case 0:
        return const AllSalesOverview();
      case 1:
        return const OnlineSalesOverview();
      case 2:
        return const WalkInSalesOverview();
      default:
        return const AllSalesOverview();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final staffRef = ref.watch(staffVm);
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      appBar: CustomAppbar(
        title: "Sales",
        trailingWidget: !staffRef.hasAccessToSales
            ? null
            : InkWell(
                onTap: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(100, 100, 0, 0),
                    items: [
                      PopupMenuItem(
                        value: 'paused_sales',
                        child: Text('Paused Sales', style: textTheme.text14),
                      ),
                      PopupMenuItem(
                        value: 'new_sales',
                        child: Text('New Sales', style: textTheme.text14),
                      ),
                      PopupMenuItem(
                        value: 'order_analytics',
                        child: Text('Order Analytics', style: textTheme.text14),
                      ),
                    ],
                  ).then((value) {
                    if (value != null) {
                      printty('Selected: $value');
                      switch (value) {
                        case 'paused_sales':
                          Navigator.pushNamed(
                              context, RoutePath.pausedSalesScreen);
                          break;
                        case 'new_sales':
                          Navigator.pushNamed(
                              context, RoutePath.newSalesScreen);
                          break;
                        case 'order_analytics':
                          Navigator.pushNamed(
                              context, RoutePath.orderAnalyticsScreen);
                          break;
                        default:
                          break;
                      }
                    }
                  });
                },
                child: SvgPicture.asset(
                  AppSvgs.circleMenu,
                  height: Sizer.height(32),
                ),
              ),
        leadingWidget: CustomCircleAvatar(
          avatarUrl: ref.read(authVmodel).user?.avatar,
          onTap: () {
            printty("avatar tapped");
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: !staffRef.hasAccessToSales
          ? RequestAccessWidget(
              isLoading: staffRef.busy(RowParams.sales),
              onRequestAccess: () async {
                final res =
                    await staffRef.requestApplicationAccess(RowParams.sales);

                handleApiResponse(response: res);
              },
            )
          : Column(
              children: [
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: Sizer.width(16)),
                        color: colorScheme.white,
                        child: Row(
                          children: [
                            ProfileTab(
                              title: "All Sales",
                              isSelected: currentIndex == 0,
                              onTap: () => _onTabChanged(0),
                            ),
                            XBox(30),
                            ProfileTab(
                              title: "Online Sales",
                              isSelected: currentIndex == 1,
                              onTap: () => _onTabChanged(1),
                            ),
                            XBox(30),
                            ProfileTab(
                              title: "Walk-in Sales",
                              isSelected: currentIndex == 2,
                              onTap: () => _onTabChanged(2),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.1, 0.0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          )),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      key: ValueKey<int>(currentIndex),
                      child: _buildTabContent(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
