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
      ref.read(vendorProfileVmodel).getVendorProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final profileVm = ref.watch(vendorProfileVmodel);
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
            padding: EdgeInsets.only(bottom: Sizer.height(30)),
            children: [
              if (profileVm.vendorProfile?.onboardingStatus != "approved")
                Padding(
                  padding: EdgeInsets.only(
                    top: Sizer.height(16),
                    left: Sizer.width(16),
                    right: Sizer.width(16),
                  ),
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
              (profileVm.vendorProfile?.logo ?? "").isEmpty
                  ? WelcomeOnboardWidget()
                  : ProfileTopWidget(
                      avatarUrl: profileVm.vendorProfile?.logo ?? "",
                      storeName: profileVm.vendorProfile?.business?.name ?? "",
                      email: profileVm.vendorProfile?.business?.email ?? "",
                      phone: profileVm.vendorProfile?.business?.phone ?? "",
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
                          "Business Profile",
                          style: textTheme.text16?.medium,
                        ),
                        XBox(8),
                        InkWell(
                          onTap: () {
                            if (profileVm.vendorProfile?.business != null) {
                              Navigator.pushNamed(
                                context,
                                RoutePath.editBusinessProfileScreen,
                                arguments: profileVm.vendorProfile!.business,
                              );
                            }
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
                            if (profileVm.vendorProfile?.finance != null) {
                              Navigator.pushNamed(
                                context,
                                RoutePath.editFinanceScreen,
                                arguments: profileVm.vendorProfile?.finance,
                              );
                            }
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
                            title: "CAC No.",
                            subTitle: profileVm.vendorProfile?.documents?.cac
                                    ?.identifier ??
                                "N/A",
                          ),
                          YBox(16),
                          ProfileColText(
                            title: "CAC Document",
                            subTitleWidget: _BuildDocRowText(
                              fileUrl:
                                  profileVm.vendorProfile?.documents?.cac?.file,
                              onTap: () {
                                final fileUrl = profileVm
                                    .vendorProfile?.documents?.cac?.file;
                                if (fileUrl != null && fileUrl != "N/A") {
                                  Navigator.pushNamed(
                                    context,
                                    RoutePath.documentViewerScreen,
                                    arguments: DocumentViewerArg(
                                      appBarText: "CAC Document",
                                      fileUrl: fileUrl,
                                      fileName: "CAC Document",
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          YBox(16),
                          ProfileColText(
                            title: "TIN No.",
                            subTitle: profileVm.vendorProfile?.documents?.cac
                                    ?.identifier ??
                                "N/A",
                          ),
                          YBox(16),
                          ProfileColText(
                            title: "TIN Document",
                            subTitleWidget: _BuildDocRowText(
                              fileUrl:
                                  profileVm.vendorProfile?.documents?.tin?.file,
                              onTap: () {
                                final fileUrl = profileVm
                                    .vendorProfile?.documents?.tin?.file;
                                if (fileUrl != null && fileUrl != "N/A") {
                                  Navigator.pushNamed(
                                    context,
                                    RoutePath.documentViewerScreen,
                                    arguments: DocumentViewerArg(
                                      appBarText: "TIN Document",
                                      fileUrl: fileUrl,
                                      fileName: "TIN Document",
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          YBox(16),
                          ProfileColText(
                            title: "Proof of address",
                            subTitleWidget: _BuildDocRowText(
                              fileUrl: profileVm
                                  .vendorProfile?.documents?.proofOfAddress
                                  ?.toString(),
                              onTap: () {
                                final fileUrl = profileVm
                                    .vendorProfile?.documents?.proofOfAddress
                                    ?.toString();
                                if (fileUrl != null && fileUrl != "N/A") {
                                  Navigator.pushNamed(
                                    context,
                                    RoutePath.documentViewerScreen,
                                    arguments: DocumentViewerArg(
                                      appBarText: "Proof of Address",
                                      fileUrl: fileUrl,
                                      fileName: "Proof of Address",
                                    ),
                                  );
                                }
                              },
                            ),
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

class _BuildDocRowText extends StatelessWidget {
  const _BuildDocRowText({
    this.fileUrl,
    this.onTap,
  });

  final String? fileUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            AppUtils.getDisplayFileName(fileUrl),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.text14?.copyWith(
              color: colorScheme.primaryColor,
            ),
          ),
          XBox(4),
          SvgPicture.asset(
            AppSvgs.arrowUpRight,
            height: Sizer.height(20),
          ),
        ],
      ),
    );
  }
}
