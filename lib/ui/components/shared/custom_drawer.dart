import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/cupertino.dart';

class CustomDrawer extends ConsumerStatefulWidget {
  const CustomDrawer({super.key});

  @override
  ConsumerState<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends ConsumerState<CustomDrawer>
    with TickerProviderStateMixin {
  late AnimationController _drawerController;
  late AnimationController _staggerController;

  // Individual section animations
  late Animation<Offset> _drawerSlideAnimation;
  late Animation<double> _drawerFadeAnimation;
  late Animation<Offset> _userProfileSlideAnimation;
  late Animation<double> _userProfileFadeAnimation;
  late Animation<Offset> _currentAccountSlideAnimation;
  late Animation<double> _currentAccountFadeAnimation;
  late Animation<Offset> _switchStoreSlideAnimation;
  late Animation<double> _switchStoreFadeAnimation;
  late Animation<Offset> _switchModuleSlideAnimation;
  late Animation<double> _switchModuleFadeAnimation;
  late Animation<Offset> _logoutSlideAnimation;
  late Animation<double> _logoutFadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _drawerController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Drawer slide in animation
    _drawerSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _drawerController,
      curve: Curves.easeOutCubic,
    ));

    _drawerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _drawerController,
      curve: Curves.easeOut,
    ));

    // Staggered section animations
    _userProfileSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _staggerController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOutQuart),
    ));

    _userProfileFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _staggerController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    ));

    _currentAccountSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _staggerController,
      curve: const Interval(0.2, 0.5, curve: Curves.easeOutQuart),
    ));

    _currentAccountFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _staggerController,
      curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
    ));

    _switchStoreSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _staggerController,
      curve: const Interval(0.4, 0.7, curve: Curves.easeOutQuart),
    ));

    _switchStoreFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _staggerController,
      curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
    ));

    _switchModuleSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _staggerController,
      curve: const Interval(0.6, 0.9, curve: Curves.easeOutQuart),
    ));

    _switchModuleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _staggerController,
      curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
    ));

    _logoutSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _staggerController,
      curve: const Interval(0.8, 1.0, curve: Curves.easeOutQuart),
    ));

    _logoutFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _staggerController,
      curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
    ));
  }

  void _startAnimations() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _drawerController.forward().then((_) {
        _staggerController.forward();
      });
    });
  }

  @override
  void dispose() {
    _drawerController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(authVmodel).user;
    final profileVm = ref.watch(userProfileVmodel);

    return Drawer(
      backgroundColor: colorScheme.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: SafeArea(
        child: SlideTransition(
          position: _drawerSlideAnimation,
          child: FadeTransition(
            opacity: _drawerFadeAnimation,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  YBox(10),
                  // User Profile Section
                  SlideTransition(
                    position: _userProfileSlideAnimation,
                    child: FadeTransition(
                      opacity: _userProfileFadeAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomCircleAvatar(
                            size: 60,
                            avatarUrl: user?.avatar,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                  context, RoutePath.settingScreen);
                            },
                          ),
                          YBox(16),
                          Text(
                            user?.name ?? '',
                            style: textTheme.text16?.medium,
                          ),
                          Text(
                            user?.email ?? '',
                            style: textTheme.text12?.copyWith(
                              color: colorScheme.black45,
                            ),
                          ),
                          YBox(2),
                          if (profileVm.userProfile?.roles?.isNotEmpty == true)
                            RadiusBorder(
                                textTheme: textTheme,
                                text:
                                    profileVm.userProfile?.roles?.first.name ??
                                        ''),
                          HDivider(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        // Current Account Section
                        SlideTransition(
                          position: _currentAccountSlideAnimation,
                          child: FadeTransition(
                            opacity: _currentAccountFadeAnimation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Current Account',
                                      style: textTheme.text12?.copyWith(
                                        color: colorScheme.black45,
                                      ),
                                    ),
                                    XBox(4),
                                    Container(
                                      height: Sizer.height(6),
                                      width: Sizer.width(6),
                                      decoration: BoxDecoration(
                                        color: AppColors.red2D,
                                        borderRadius: BorderRadius.circular(
                                            Sizer.radius(4)),
                                      ),
                                    )
                                  ],
                                ),
                                Text('Builder\'s Hub Constructions',
                                    style: textTheme.text14),
                                YBox(10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: RadiusBorder(
                                    textTheme: textTheme,
                                    text: profileVm.currentStore?.name ?? '',
                                    borderColor: AppColors.blue0FF,
                                    bgColor: AppColors.blueFF,
                                    textColor: AppColors.primaryBlue,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Sizer.height(16)),
                                  child: Divider(
                                      color: AppColors.neutral4, height: 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Switch Store
                        SlideTransition(
                          position: _switchStoreSlideAnimation,
                          child: FadeTransition(
                            opacity: _switchStoreFadeAnimation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Switch store',
                                  style: textTheme.text12?.copyWith(
                                    color: colorScheme.black45,
                                  ),
                                ),
                                YBox(6),
                                SizedBox(
                                  height: Sizer.height(200),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(
                                      top: Sizer.height(16),
                                    ),
                                    separatorBuilder: (context, index) =>
                                        YBox(13),
                                    itemCount:
                                        profileVm.userProfile?.store?.length ??
                                            0,
                                    itemBuilder: (ctx, i) {
                                      final store =
                                          profileVm.userProfile?.store?[i];
                                      return SwitchValueTile(
                                        isSelected: store?.current == true,
                                        title:
                                            (store?.name ?? '').capitalizeFirst,
                                        isLoading: ref
                                            .watch(storeVmodel)
                                            .busy(store?.id),
                                        onTap: () async {
                                          final storeRes = await ref
                                              .read(storeVmodel)
                                              .switchStore(
                                                storeId: store?.id ?? '',
                                                busyObjectName: store?.id,
                                              );

                                          handleApiResponse(
                                            response: storeRes,
                                            onSuccess: () {
                                              ref
                                                  .read(userProfileVmodel)
                                                  .getUserProfile();
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                HDivider(),
                              ],
                            ),
                          ),
                        ),

                        // Switch Module
                        SlideTransition(
                          position: _switchModuleSlideAnimation,
                          child: FadeTransition(
                            opacity: _switchModuleFadeAnimation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Switch module',
                                  style: textTheme.text12?.copyWith(
                                    color: colorScheme.black45,
                                  ),
                                ),
                                YBox(6),
                                SwitchValueTile(
                                  title: "Point of Sales",
                                  isSelected: true,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                // SwitchValueTile(
                                //   title: "Accounting",
                                //   onTap: () {
                                //     Navigator.pop(context);
                                //   },
                                // ),
                                // SwitchValueTile(
                                //   title: "Procurement",
                                //   onTap: () {
                                //     Navigator.pop(context);
                                //   },
                                // ),

                                HDivider(),
                              ],
                            ),
                          ),
                        ),

                        // Logout Button
                        SlideTransition(
                          position: _logoutSlideAnimation,
                          child: FadeTransition(
                            opacity: _logoutFadeAnimation,
                            child: Column(
                              children: [
                                CustomBtn.withChild(
                                  isOutline: true,
                                  height: Sizer.height(40),
                                  onTap: () {
                                    ModalWrapper.bottomSheet(
                                      context: context,
                                      widget: ConfirmationModal(
                                        modalConfirmationArg:
                                            ModalConfirmationArg(
                                          iconPath: AppSvgs.infoCircleRed,
                                          title: "Log out",
                                          description:
                                              "Are you sure you want to log out of this account? Your last changes will be saved.",
                                          solidBtnText: "Yes, Logout",
                                          onSolidBtnOnTap: () {
                                            final ctx = NavKey
                                                .appNavKey.currentContext!;
                                            Navigator.pop(ctx);
                                            Navigator.pop(ctx);
                                            ref.read(authVmodel).logout();
                                          },
                                          onOutlineBtnOnTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(AppSvgs.logout),
                                      XBox(8),
                                      Text(
                                        'Logout',
                                        style: textTheme.text16?.copyWith(
                                          color: AppColors.red22,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                YBox(20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SwitchValueTile extends StatelessWidget {
  const SwitchValueTile({
    super.key,
    required this.title,
    this.isSelected = false,
    this.isLoading = false,
    this.onTap,
  });

  final String title;
  final bool isSelected;
  final bool isLoading;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Sizer.height(8)),
        child: Row(
          children: [
            Text(title, style: textTheme.text14),
            Spacer(),
            isLoading
                ? CupertinoActivityIndicator()
                : isSelected
                    ? SvgPicture.asset(AppSvgs.checkCircleOutline)
                    : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class RadiusBorder extends StatelessWidget {
  const RadiusBorder({
    super.key,
    required this.textTheme,
    required this.text,
    this.borderColor,
    this.bgColor,
    this.textColor,
  });

  final TextTheme textTheme;
  final String text;
  final Color? borderColor;
  final Color? bgColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(8),
        vertical: Sizer.height(2),
      ),
      decoration: BoxDecoration(
        color: bgColor ?? AppColors.neutral2,
        border: Border.all(color: borderColor ?? AppColors.neutral5),
        borderRadius: BorderRadius.circular(Sizer.radius(16)),
      ),
      child: Text(
        text,
        style: textTheme.text12?.copyWith(color: textColor),
      ),
    );
  }
}
