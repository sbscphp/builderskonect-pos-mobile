// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileVmodel)
        ..getVendorProfile()
        ..getUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final profileVm = ref.watch(profileVmodel);
    return Scaffold(
        appBar: CustomAppbar(
          title: "Settings",
          trailingWidget: InkWell(
            onTap: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  PopupMenuItem(
                    value: 'change_password',
                    child: Text('Change Password', style: textTheme.text14),
                  ),
                  PopupMenuItem(
                    value: 'log_out',
                    child: Text('Log out',
                        style: textTheme.text14?.copyWith(
                          color: AppColors.red2D,
                        )),
                  ),
                ],
              ).then((value) {
                if (value != null) {
                  printty('Selected: $value');
                  switch (value) {
                    case 'change_password':
                      Navigator.pushNamed(
                          context, RoutePath.changePasswordScreen);
                      break;
                    case 'log_out':
                      final loadingProvider =
                          StateProvider<bool>((ref) => false);
                      ModalWrapper.bottomSheet(
                        context: context,
                        widget: Consumer(builder: (context, ref, child) {
                          final isLoading = ref.watch(loadingProvider);
                          return ConfirmationModal(
                            modalConfirmationArg: ModalConfirmationArg(
                              iconPath: AppSvgs.infoCircleRed,
                              title: "Log out",
                              description:
                                  "Are you sure you want to log out of this account? Your last changes will be saved.",
                              solidBtnText: "Yes, Logout",
                              isLoading: isLoading,
                              onSolidBtnOnTap: () async {
                                // Set loading to true
                                ref.read(loadingProvider.notifier).state = true;
                                try {
                                  await ref.read(authVmodel).logout();
                                } finally {
                                  // Check if the widget is still mounted before using ref
                                  if (context.mounted) {
                                    ref.read(loadingProvider.notifier).state =
                                        false;
                                  }
                                }
                              },
                              onOutlineBtnOnTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          );
                        }),
                      );
                      break;
                    default:
                      break;
                  }
                }
              });
            },
            child: Icon(
              Icons.more_vert,
              color: colorScheme.black85,
            ),
          ),
        ),
        body: LoadableContentBuilder(
            isBusy: profileVm.isBusy,
            loadingBuilder: (p0) {
              return SizerLoader(
                height: double.infinity,
              );
            },
            emptyBuilder: (context) {
              return Center(
                child: Text(
                  "No Data",
                  style: textTheme.text14?.medium.copyWith(
                    color: AppColors.gray500,
                  ),
                ),
              );
            },
            contentBuilder: (context) {
              return ListView(
                padding: EdgeInsets.only(
                  bottom: Sizer.height(50),
                ),
                children: [
                  YBox(16),
                  ProfileTopWidget(
                    avatarUrl: profileVm.userProfile?.avatar ?? "",
                    storeName: profileVm.userProfile?.name ?? "",
                    email: profileVm.userProfile?.email ?? "",
                    phone: profileVm.userProfile?.phone ?? "",
                  ),
                  YBox(16),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
                    padding: EdgeInsets.symmetric(
                      horizontal: Sizer.width(16),
                      vertical: Sizer.height(16),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizer.radius(4)),
                      color: colorScheme.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "User Profile",
                              style: textTheme.text16?.medium,
                            ),
                          ],
                        ),
                        YBox(16),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(Sizer.radius(16)),
                          decoration: BoxDecoration(
                            color: AppColors.neutral3,
                            borderRadius:
                                BorderRadius.circular(Sizer.radius(4)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProfileColText(
                                title: "Business name",
                                subTitle: "Builder’s Hub Construction",
                              ),
                              YBox(16),
                              ProfileColText(
                                title: "Business email",
                                subTitle: "buildershub@gmail.com",
                              ),
                              YBox(16),
                              ProfileColText(
                                title: "Business category",
                                subTitle: "Construction",
                              ),
                              YBox(16),
                              ProfileColText(
                                title: "Business type",
                                subTitle: "Full time",
                              ),
                              YBox(16),
                              ProfileColText(
                                title: "Business phone number",
                                subTitle: "+234 80 2424 24212",
                              ),
                              YBox(16),
                              ProfileColText(
                                title: "Vendor ID",
                                subTitle: "123456",
                                onCopy: () {},
                              ),
                              YBox(16),
                              ProfileColText(
                                title: "Business address",
                                subTitle: "123 Main St, Anytown, USA",
                              ),
                              YBox(16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }));
  }
}
