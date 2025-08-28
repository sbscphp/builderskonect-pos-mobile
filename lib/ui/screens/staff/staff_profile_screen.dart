import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/services.dart';

class StaffProfileScreen extends ConsumerStatefulWidget {
  final String staffId;
  const StaffProfileScreen({super.key, required this.staffId});

  @override
  ConsumerState<StaffProfileScreen> createState() => _StaffProfileScreenState();
}

class _StaffProfileScreenState extends ConsumerState<StaffProfileScreen> {
  late MenuController _controller;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserDetails();
    });
  }

  _fetchUserDetails() async {
    await ref.read(staffVm).viewStaff(staffID: widget.staffId);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final vm = ref.watch(staffVm);
    final isActive = vm.viewedStaff?.status?.toLowerCase() == 'active';

    return Scaffold(
      appBar: CustomAppbar(
        title: "Vendor Profile",
        trailingWidget: MenuAnchor(
            builder: (context, controller, child) {
              _controller = controller;
              return InkWell(
                onTap: _validateUserStatus()
                    ? () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      }
                    : null,
                child: SvgPicture.asset(AppSvgs.menu),
              );
            },
            menuChildren: [
              InkWell(
                onTap: () {
                  _controller.close();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 6),
                  color: isActive ? AppColors.blue2 : Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      isActive
                          ? Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 16,
                                  color: AppColors.blueDD9,
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                              ],
                            )
                          : SizedBox(
                              width: 20.h,
                            ),
                      Text(
                        "Active",
                        style: textTheme.bodyMedium?.copyWith(
                            fontWeight:
                                isActive ? FontWeight.bold : FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _controller.close();
                  ModalWrapper.bottomSheet(
                      context: context,
                      widget: ConfirmationModal(
                          modalConfirmationArg: ModalConfirmationArg(
                        iconPath: AppSvgs.infoCircleRed,
                        title: "Deactivate Staff",
                        description:
                            "Are you sure you want to deactivate this staff? This staff will no longer have access to the platform once deactivated.",
                        solidBtnText: "Yes, deactivate",
                        outlineBtnText: "No, don’t",
                        onOutlineBtnOnTap: () {
                          Navigator.pop(context);
                        },
                        onSolidBtnOnTap: () async {
                          Navigator.pop(context);

                          final res = await vm.updateStaff(isActive: 0);

                          handleApiResponse(response: res);
                        },
                      )));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 6),
                  color: !isActive ? AppColors.blue2 : Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      !isActive
                          ? Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 16,
                                  color: AppColors.blueDD9,
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                              ],
                            )
                          : SizedBox(
                              width: 20.h,
                            ),
                      Text(
                        "Deactivate",
                        style: textTheme.bodyMedium?.copyWith(
                            fontWeight: !isActive
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
      ),
      body: SizedBox(
        height: Sizer.screenHeight,
        width: Sizer.screenWidth,
        child: BusyOverlay(
          show: vm.isBusy,
          child: RefreshIndicator(
            onRefresh: () async {
              _fetchUserDetails();
            },
            child: ListView(
              padding: EdgeInsets.only(
                top: Sizer.height(16),
              ),
              children: [
                ProfileTopWidget(
                  avatarUrl: vm.viewedStaff?.avatar ?? '',
                  storeName: vm.viewedStaff?.name ?? '',
                  email: vm.viewedStaff?.email ?? '',
                  phone: vm.viewedStaff?.phone ?? '',
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
                          XBox(8),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoutePath.editStaffScreen);
                            },
                            child: SvgPicture.asset(AppSvgs.profileEdit),
                          ),
                        ],
                      ),
                      YBox(16),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(Sizer.radius(16)),
                        decoration: BoxDecoration(
                          color: AppColors.neutral3,
                          borderRadius: BorderRadius.circular(Sizer.radius(4)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileColText(
                              title: "Full name",
                              subTitle: vm.viewedStaff?.name ?? '',
                            ),
                            YBox(16),
                            ProfileColText(
                              title: "Email",
                              subTitle: vm.viewedStaff?.email ?? '',
                            ),
                            YBox(16),
                            ProfileColText(
                                title: "Phone umber",
                                subTitle: vm.viewedStaff?.phone ?? ''),
                            YBox(16),
                            ProfileColText(
                              title: "Role",
                              subTitle: vm.viewedStaff?.assignedRoles ?? '',
                            ),
                            YBox(16),
                            ProfileColText(
                              title: "Store",
                              subTitle:
                                  (vm.viewedStaff?.store?.isNotEmpty ?? false)
                                      ? vm.viewedStaff?.store?.first['name'] ??
                                          'N/A'
                                      : "", //todo:::: handle store
                            ),
                            YBox(16),
                            ProfileColText(
                                title: "User ID",
                                subTitle: vm.viewedStaff?.staffId ?? '',
                                onCopy: () async {
                                  await Clipboard.setData(ClipboardData(
                                    text: vm.viewedStaff?.staffId ?? "",
                                  ));
                                  showSuccessToastMessage("Copied");
                                }),
                            YBox(16),
                            ProfileColText(
                              title: "Last Active",
                              subTitle: AppUtils.convertDateTime(
                                  vm.viewedStaff?.lastActive ?? DateTime.now()),
                            ),
                            YBox(16),
                            ProfileColText(
                              title: "Status",
                              subTitleWidget: OrderStatus(
                                  status: vm.viewedStaff?.status ?? ''),
                            ),
                            YBox(16),
                          ],
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
    );
  }

  bool _validateUserStatus() {
    final user = ref.watch(staffVm).viewedStaff;
    return user?.status?.toLowerCase() == 'active' ||
        user?.status?.toLowerCase() == 'deactivated';
  }
}
