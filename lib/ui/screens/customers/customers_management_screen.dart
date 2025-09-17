import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class CustomersManagementScreen extends ConsumerStatefulWidget {
  const CustomersManagementScreen({super.key});

  @override
  ConsumerState<CustomersManagementScreen> createState() =>
      _CustomersManagementScreenState();
}

class _CustomersManagementScreenState
    extends ConsumerState<CustomersManagementScreen>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  late AnimationController _tabController;
  late Animation<double> _fadeAnimation;
  final searchC = TextEditingController();

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

  @override
  void dispose() {
    _tabController.dispose();
    searchC.dispose();
    super.dispose();
  }

  Widget _buildTabContent() {
    switch (currentIndex) {
      case 0:
        return const AllCustomersTab();
      case 1:
        return const OnlineCustomersTab();
      case 2:
        return const WalkInCustomersTab();
      default:
        return const AllCustomersTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final staffRef = ref.watch(staffVm);
    return Scaffold(
      appBar: CustomAppbar(
        title: "Customers Management",
        trailingWidget: !staffRef.hasAccessToCustomerOverview
            ? null
            : InkWell(
                onTap: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(100, 100, 0, 0),
                    items: [
                      // PopupMenuItem(
                      //   value: 'new_customer',
                      //   child:
                      //       Text('Add New Customer', style: textTheme.text14),
                      // ),
                      PopupMenuItem(
                        value: 'reviews',
                        child: Text('Reviews and Feedback',
                            style: textTheme.text14),
                      ),
                    ],
                  ).then((value) {
                    if (value != null && context.mounted) {
                      printty('Selected: $value');
                      switch (value) {
                        // case 'new_customer':
                        //   Navigator.pushNamed(
                        //       context, RoutePath.newCustomerScreen);
                        //   break;
                        case 'reviews':
                          // Navigator.pushNamed(context, RoutePath.reviewsScreen);
                          break;

                        default:
                          break;
                      }
                    }
                  });
                },
                child: SvgPicture.asset(AppSvgs.menu),
              ),
      ),
      body: !staffRef.hasAccessToCustomerOverview
          ? RequestAccessWidget(
              isLoading: staffRef.busy(RowParams.customer),
              onRequestAccess: () async {
                final res =
                    await staffRef.requestApplicationAccess(RowParams.customer);

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
                              title: "All Customers",
                              isSelected: currentIndex == 0,
                              onTap: () => _onTabChanged(0),
                            ),
                            XBox(30),
                            ProfileTab(
                              title: "Online",
                              isSelected: currentIndex == 1,
                              onTap: () => _onTabChanged(1),
                            ),
                            XBox(30),
                            ProfileTab(
                              title: "Walk-in",
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
