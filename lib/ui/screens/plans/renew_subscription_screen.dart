import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class RenewSubscriptionScreen extends ConsumerStatefulWidget {
  const RenewSubscriptionScreen({
    super.key,
    required this.subcriptionArg,
  });

  final SubcriptionArg subcriptionArg;

  @override
  ConsumerState<RenewSubscriptionScreen> createState() =>
      _RenewSubscriptionScreenState();
}

class _RenewSubscriptionScreenState
    extends ConsumerState<RenewSubscriptionScreen> {
  final discountCodeC = TextEditingController();
  final discountCodeFocus = FocusNode();

  PlanBreakDownModel? _planBreakDownModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initSetup();
    });
  }

  Future<ApiResponse> _initSetup(
      [String? discountCode, bool showDiscountState = false]) async {
    final res = await ref.read(subscriptionVModel).subscriptionBreakDown(
          priceItemId: widget.subcriptionArg.priceItemId,
          discountCode: discountCode,
          showDiscountState: showDiscountState,
        );

    if (res.success) {
      _planBreakDownModel = res.data;
      setState(() {});
    }
    return res;
  }

  @override
  void dispose() {
    discountCodeC.dispose();
    discountCodeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final subscriptionVm = ref.watch(subscriptionVModel);
    return BusyOverlay(
      show: subscriptionVm.isBusy,
      child: Scaffold(
        backgroundColor: colorScheme.white,
        appBar: CustomAppbar(
          title: widget.subcriptionArg.isUpgrade ? "" : " Renew Subscription",
        ),
        body: LoadableContentBuilder(
            isError: subscriptionVm.hasError,
            isBusy: false,
            loadingBuilder: (ctx) {
              return SizedBox.shrink();
              // return SizerLoader(
              //   height: double.infinity,
              // );
            },
            errorBuilder: (ctx) {
              return ErrorState(
                message: subscriptionVm.apiResponse.message ??
                    "Failed to load subscription details",
                onPressed: () {
                  _initSetup();
                },
              );
            },
            emptyBuilder: (ctx) {
              return Center(
                child: Text(
                  "No Data",
                  style: textTheme.text14?.medium.copyWith(
                    color: AppColors.gray500,
                  ),
                ),
              );
            },
            contentBuilder: (ctx) {
              return ListView(
                padding: EdgeInsets.only(
                  left: Sizer.width(16),
                  right: Sizer.width(16),
                  bottom: Sizer.height(50),
                ),
                children: [
                  YBox(16),
                  Container(
                    padding: EdgeInsets.all(Sizer.radius(16)),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.neutral4),
                      borderRadius: BorderRadius.circular(Sizer.radius(8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Payment Summary",
                          style: textTheme.text16?.medium,
                        ),
                        YBox(16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 9,
                              child: CustomTextField(
                                controller: discountCodeC,
                                focusNode: discountCodeFocus,
                                isRequired: false,
                                labelText: 'Apply Discount Code ',
                                optionalText: '(if any)',
                                hintText: 'GT27365ER',
                                showLabelHeader: true,
                              ),
                            ),
                            XBox(8),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: Sizer.height(7),
                                ),
                                child: CustomBtn(
                                  isLoading: subscriptionVm.busy(discountState),
                                  height: 44,
                                  text: "Apply",
                                  onTap: () async {
                                    if (discountCodeC.text.trim().isNotEmpty) {
                                      final res = await _initSetup(
                                        discountCodeC.text.trim(),
                                        true,
                                      );

                                      handleApiResponse(
                                        response: res,
                                        showSuccessToast: false,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        YBox(16),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Sizer.width(16),
                            vertical: Sizer.height(20),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.dayBreakBlue,
                            borderRadius:
                                BorderRadius.circular(Sizer.radius(8)),
                          ),
                          child: Column(
                            children: [
                              PlansRowText(
                                keyText: widget.subcriptionArg.planName,
                                valueText:
                                    "${AppUtils.nairaSymbol}${AppUtils.formatNumber(number: double.tryParse(_planBreakDownModel?.planAmount ?? '0') ?? 0)}",
                              ),
                              YBox(14),
                              PlansRowText(
                                keyText: "Discount",
                                valueText:
                                    "${AppUtils.nairaSymbol}${AppUtils.formatNumber(number: _planBreakDownModel?.discountAmount ?? 0)}",
                              ),
                              YBox(14),
                              PlansRowText(
                                keyText: "VAT",
                                valueText:
                                    "${AppUtils.nairaSymbol}${AppUtils.formatNumber(number: _planBreakDownModel?.vatAmount ?? 0)}",
                              ),
                              YBox(14),
                              PlansRowText(
                                keyText: "Total Cost",
                                valueText:
                                    "${AppUtils.nairaSymbol}${AppUtils.formatNumber(number: _planBreakDownModel?.amountDue ?? 0)}",
                                keyTextStyle: textTheme.text16,
                                valueTextStyle: textTheme.text16?.bold.copyWith(
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  YBox(30),
                  CustomBtn.solid(
                    text: "Continue",
                    onTap: () async {
                      final res =
                          await ref.read(subscriptionVModel).selectInitialPlan(
                                priceItemId: widget.subcriptionArg.priceItemId,
                                discount: discountCodeC.text,
                                callbackUrl:
                                    "${AppConfig.callBackUrl}/profile/subscription/success",
                              );

                      handleApiResponse(
                        response: res,
                        onSuccess: () {
                          Navigator.pushNamed(
                            context,
                            RoutePath.customWebviewScreen,
                            arguments: WebViewArg(
                              webURL: res.data["data"]["authorization_url"],
                              onSucecess: () async {
                                Navigator.pop(context);

                                // subscribe the user
                                final result = await ref
                                    .read(subscriptionVModel)
                                    .subscribePlanVerify(
                                      res.data["data"]["reference"],
                                    );

                                handleApiResponse(
                                  response: result,
                                  onSuccess: () {
                                    ModalWrapper.bottomSheet(
                                      context: context,
                                      canDismiss: false,
                                      widget: ConfirmationModal(
                                        modalConfirmationArg:
                                            ModalConfirmationArg(
                                          iconPath: AppSvgs.checkIcon,
                                          title: "Payment Successful",
                                          description:
                                              "Subscription payment verified successfully",
                                          solidBtnText: "Okay, continue",
                                          onSolidBtnOnTap: () {
                                            final ctx = NavKey
                                                .appNavKey.currentContext!;
                                            Navigator.pop(ctx);
                                            Navigator.of(context).popUntil(
                                                (route) =>
                                                    route.settings.name ==
                                                    RoutePath.bottomNavScreen);

                                            // Navigator.pushNamed(
                                            //   ctx,
                                            //   RoutePath
                                            //       .subscriptionSuccessScreen,
                                            //   arguments: SubscriptionSuccessArg(
                                            //     header:
                                            //         "Subscription Successful!",
                                            //     content:
                                            //         AppText.subcriptionSuccess,
                                            //     btnText: "Register as a Vendor",
                                            //     onTap: () {
                                            //       Navigator
                                            //           .pushReplacementNamed(
                                            //         ctx,
                                            //         RoutePath
                                            //             .vendorRegistrationScreen,
                                            //         arguments: res.data["data"]
                                            //             ["reference"],
                                            //       );
                                            //     },
                                            //   ),
                                            // );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              );
            }),
      ),
    );
  }
}
