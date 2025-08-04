import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/services.dart';

class ProfileInformationTab extends ConsumerStatefulWidget {
  const ProfileInformationTab({
    super.key,
  });

  @override
  ConsumerState<ProfileInformationTab> createState() =>
      _ProfileInformationTabState();
}

class _ProfileInformationTabState extends ConsumerState<ProfileInformationTab> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileVmodel).getVendorProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final profileVm = ref.watch(profileVmodel);
    return LoadableContentBuilder(
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
            children: [
              YBox(16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
                child: InfoContainer(
                  show: _isExpanded,
                  title: "Account Under Review",
                  content:
                      "Your account has not yet being verified. You will gain access to the full features when your account is approved.",
                  onTap: () {
                    _isExpanded = !_isExpanded;
                    setState(() {});
                  },
                ),
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
                child: Row(
                  children: [
                    CustomCircleAvatar(
                      size: 60,
                      avatarUrl: "",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, RoutePath.profileScreen);
                      },
                    ),
                    XBox(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome Onboard!',
                              style: textTheme.text16?.medium.copyWith(
                                color: AppColors.primaryBlue,
                              )),
                          YBox(2),
                          Text(
                            "Complete your business profile by uploading your business logo",
                            style: textTheme.text12?.copyWith(
                              color: AppColors.neutral8,
                            ),
                          ),
                          YBox(8),
                          CustomBtn(
                            height: Sizer.height(38),
                            width: Sizer.width(90),
                            text: "Upload Logo",
                            isOutline: true,
                            textStyle: textTheme.text12?.copyWith(
                              color: AppColors.primaryBlue,
                            ),
                            onTap: () {},
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              YBox(16),
              // ProfileTopWidget(),
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
                          "Business Profile",
                          style: textTheme.text16?.medium,
                        ),
                        XBox(8),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutePath.editProfileScreen);
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
                            title: "Business name",
                            subTitle:
                                profileVm.vendorProfile?.business?.name ?? "",
                          ),
                          YBox(16),
                          ProfileColText(
                            title: "Business email",
                            subTitle:
                                profileVm.vendorProfile?.business?.email ?? "",
                          ),
                          YBox(16),
                          ProfileColText(
                            title: "Business category",
                            subTitle:
                                profileVm.vendorProfile?.business?.category ??
                                    "",
                          ),
                          YBox(16),
                          ProfileColText(
                            title: "Business type",
                            subTitle:
                                profileVm.vendorProfile?.business?.type ?? "",
                          ),
                          YBox(16),
                          ProfileColText(
                            title: "Business phone number",
                            subTitle:
                                profileVm.vendorProfile?.business?.phone ?? "",
                          ),
                          YBox(16),
                          ProfileColText(
                            title: "Vendor ID",
                            subTitle: profileVm.vendorProfile?.id ?? "",
                            onCopy: () async {
                              await Clipboard.setData(ClipboardData(
                                text: profileVm.vendorProfile?.id ?? "",
                              ));
                              showSuccessToastMessage("Copied");
                            },
                          ),
                          YBox(16),
                          ProfileColText(
                            title: "Business address",
                            subTitle:
                                profileVm.vendorProfile?.business?.address ??
                                    "",
                          ),
                          YBox(16),
                        ],
                      ),
                    ),
                  ],
                ),
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
                          "Bank Details",
                          style: textTheme.text16?.medium,
                        ),
                        XBox(8),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutePath.editFinanceScreen);
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
                            title: "Bank name",
                            subTitle:
                                profileVm.vendorProfile?.finance?.bankName ??
                                    "",
                          ),
                          YBox(16),
                          ProfileColText(
                            title: "Account number",
                            subTitle: profileVm
                                    .vendorProfile?.finance?.accountNumber ??
                                "",
                          ),
                          YBox(16),
                          ProfileColText(
                            title: "Account name",
                            subTitle:
                                profileVm.vendorProfile?.finance?.accountName ??
                                    "",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                          "Documents",
                          style: textTheme.text16?.medium,
                        ),
                        XBox(8),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutePath.editDocumentsScreen);
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
                            title: "CAC No",
                            subTitle: "1234567890",
                          ),
                          YBox(16),
                          ProfileColText(
                            title: "CAC Document",
                            subTitle: "1234567890",
                          ),
                          YBox(16),
                          ProfileColText(
                            title: "Account name",
                            subTitle: "Construction",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
