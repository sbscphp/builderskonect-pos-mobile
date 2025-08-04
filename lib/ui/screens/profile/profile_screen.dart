// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
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
      default:
        return const ProfileInformationTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppbar(
        bgColor: AppColors.transparent,
        title: "Vendor Profile",
        trailingWidget: InkWell(
            onTap: () {
              Navigator.pushNamed(context, RoutePath.contactSupportScreen);
            },
            child: SvgPicture.asset(AppSvgs.support)),
      ),
      body: Column(
        children: [
          YBox(10),
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
                  color: colorScheme.white,
                  child: Row(
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
                    ],
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
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
