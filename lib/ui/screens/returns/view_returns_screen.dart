// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ViewReturnsScreen extends ConsumerStatefulWidget {
  const ViewReturnsScreen({super.key, required this.refund});

  final RefundData refund;

  @override
  ConsumerState<ViewReturnsScreen> createState() => _ViewReturnsScreenState();
}

class _ViewReturnsScreenState extends ConsumerState<ViewReturnsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(refundReturnsVm).viewDetails(widget.refund.id ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final refundVm = ref.watch(refundReturnsVm);
    final returnDetials = refundVm.returnRefurnDetailsModel;
    return Scaffold(
      appBar: CustomAppbar(
        title: "View returns",
        trailingWidget: InkWell(
          onTap: () {
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(100, 100, 0, 0),
              items: [
                PopupMenuItem(
                  value: 'approve_all',
                  child: Text('Approve all', style: textTheme.text14),
                ),
                PopupMenuItem(
                  value: 'reject_all',
                  child: Text('Reject all',
                      style: textTheme.text14?.copyWith(
                        color: AppColors.red2D,
                      )),
                ),
              ],
            ).then((value) {
              if (value != null) {
                printty('Selected: $value');
                switch (value) {
                  case 'approve_all':
                    // Navigator.pushNamed(
                    //     context, RoutePath.changePasswordScreen);
                    break;
                  case 'reject_all':
                    // final loadingProvider = StateProvider<bool>((ref) => false);
                    // ModalWrapper.bottomSheet(
                    //   context: context,
                    //   widget: Consumer(builder: (context, ref, child) {
                    //     final isLoading = ref.watch(loadingProvider);
                    //     return ConfirmationModal(
                    //       modalConfirmationArg: ModalConfirmationArg(
                    //         iconPath: AppSvgs.infoCircleRed,
                    //         title: "Log out",
                    //         description:
                    //             "Are you sure you want to log out of this account? Your last changes will be saved.",
                    //         solidBtnText: "Yes, Logout",
                    //         isLoading: isLoading,
                    //         onSolidBtnOnTap: () async {
                    //           // Set loading to true
                    //           ref.read(loadingProvider.notifier).state = true;
                    //           try {
                    //             await ref.read(authVmodel).logout();
                    //           } finally {
                    //             // Check if the widget is still mounted before using ref
                    //             if (context.mounted) {
                    //               ref.read(loadingProvider.notifier).state =
                    //                   false;
                    //             }
                    //           }
                    //         },
                    //         onOutlineBtnOnTap: () {
                    //           Navigator.pop(context);
                    //         },
                    //       ),
                    //     );
                    //   }),
                    // );
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
        isBusy: refundVm.isBusy,
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
                    FilterHeader(
                      title: "Returns & Refund Overview",
                      subTitle: "View and manage logged returns ",
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
                            title: "RETURN ID -",
                            title2: "ONLINE",
                            subTitle: returnDetials?.id ?? "",
                          ),
                          YBox(16),
                          ProfileColText(
                            title: "Customer Name",
                            subTitle: returnDetials?.customerName ?? "",
                          ),
                          YBox(16),
                          ProfileColText(
                            title: "Email",
                            subTitle: returnDetials?.customerEmail ?? "",
                          ),
                          YBox(16),
                          ProfileColText(
                            title: "Phone number",
                            subTitle: returnDetials?.customerPhone ?? "",
                          ),
                          YBox(16),
                          ProfileColText(
                              title: "Order ID",
                              subTitle: "#${returnDetials?.orderId ?? "N/A"}"),
                          YBox(16),
                          ProfileColText(
                            title: "No of Order",
                            subTitle:
                                returnDetials?.ordersCount?.toString() ?? "N/A",
                          ),
                          YBox(16),
                          ProfileColText(
                            title: "Returns Amount",
                            subTitle:
                                "${AppUtils.nairaSymbol}${AppUtils.formatNumber(
                              decimalPlaces: 2,
                              number: double.tryParse(
                                      returnDetials?.totalAmountRefunded ??
                                          "0") ??
                                  0,
                            )}",
                          ),
                          YBox(16),
                          ProfileColText(
                              title: "Discount",
                              subTitle: returnDetials?.discount ?? "N/A"),
                          Padding(
                            padding: EdgeInsets.only(
                              top: Sizer.height(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Refund Status",
                                  style: textTheme.text12?.copyWith(
                                    color: AppColors.grey175,
                                  ),
                                ),
                                YBox(6),
                                OrderStatus(
                                  status: returnDetials?.status ?? "N/A",
                                ),
                              ],
                            ),
                          ),
                          YBox(16),
                          ProfileColText(title: "Refund Type", subTitle: "N/A"),
                          YBox(16),
                          ProfileColText(
                            title: "Payment Methods",
                            subTitle: (returnDetials?.paymentMethod ?? [])
                                .map((payment) =>
                                    "${payment.name}: ${AppUtils.nairaSymbol}${AppUtils.formatNumber(
                                      decimalPlaces: 2,
                                      number: double.tryParse(
                                              payment.amount ?? "0") ??
                                          0,
                                    )}")
                                .join(", "),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
