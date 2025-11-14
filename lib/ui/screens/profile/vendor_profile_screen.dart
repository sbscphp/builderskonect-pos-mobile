// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class VendorProfileScreen extends ConsumerStatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  ConsumerState<VendorProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<VendorProfileScreen>
    with TickerProviderStateMixin {
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        return const ProfileInformationTab();
      case 1:
        return const StoresTab();
      case 2:
        return const SubscriptionTab();
      case 3:
        return AccreditationTab();
      default:
        return const ProfileInformationTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final staffRef = ref.watch(staffVm);
    return Scaffold(
      appBar: CustomAppbar(
        leadingWidget: SizedBox.shrink(),
        bgColor: AppColors.transparent,
        title: "Vendor Profile",
        trailingWidget: InkWell(
            onTap: () {
              Navigator.pushNamed(context, RoutePath.contactSupportScreen);
            },
            child: SvgPicture.asset(AppSvgs.support)),
      ),
      body: !staffRef.hasAccessToVendorProfile
          ? RequestAccessWidget(
              isLoading: staffRef.busy(RowParams.vendorProfile),
              onRequestAccess: () async {
                final res = await staffRef
                    .requestApplicationAccess(RowParams.vendorProfile);

                handleApiResponse(response: res);
              },
            )
          : Column(
              children: [
                YBox(10),
                SizedBox(
                  height: 55,
                  child: AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Sizer.width(16)),
                            color: colorScheme.white,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                ProfileTab(
                                  title: "Profile Information",
                                  isSelected: currentIndex == 0,
                                  onTap: () => _onTabChanged(0),
                                ),
                                XBox(30),
                                ProfileTab(
                                  title: "Stores",
                                  isSelected: currentIndex == 1,
                                  onTap: () => _onTabChanged(1),
                                ),
                                XBox(30),
                                ProfileTab(
                                  title: "Subscription",
                                  isSelected: currentIndex == 2,
                                  onTap: () => _onTabChanged(2),
                                ),
                                XBox(30),
                                ProfileTab(
                                  title: "Accreditation",
                                  isSelected: currentIndex == 3,
                                  onTap: () => _onTabChanged(3),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
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
