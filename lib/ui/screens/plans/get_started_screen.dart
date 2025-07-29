import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/services.dart';

class GetStartedScreen extends ConsumerStatefulWidget {
  const GetStartedScreen({super.key, required this.arg});

  final PlanFeatureArg? arg;

  @override
  ConsumerState<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends ConsumerState<GetStartedScreen> {
  final _formKey = GlobalKey<FormState>();
  final fullNameC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final companyNameC = TextEditingController();
  final discountCodeC = TextEditingController();

  final fullNameFocus = FocusNode();
  final emailFocus = FocusNode();
  final phoneFocus = FocusNode();
  final companyNameFocus = FocusNode();
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
          priceItemId: widget.arg?.priceItem.id ?? "",
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
    fullNameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    companyNameC.dispose();
    discountCodeC.dispose();

    fullNameFocus.dispose();
    emailFocus.dispose();
    phoneFocus.dispose();
    companyNameFocus.dispose();
    discountCodeFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final subVm = ref.watch(subscriptionVModel);
    return BusyOverlay(
      show: subVm.isBusy,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppbar(title: ""),
        body: ListView(
          padding: EdgeInsets.only(
            left: Sizer.width(16),
            right: Sizer.width(16),
            top: Sizer.height(16),
            bottom: Sizer.height(60),
          ),
          children: [
            Text(
              "Get started on Builder’sKonnect",
              style: textTheme.text20?.medium,
            ),
            YBox(4),
            Text(
              "Fill the information below and subscribe to begin your experience.",
              style: textTheme.text16?.copyWith(
                color: colorScheme.black45,
              ),
            ),
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
                            isLoading: subVm.busy(discountState),
                            height: 44,
                            text: "Apply",
                            onTap: () async {
                              if (discountCodeC.text.trim().isNotEmpty) {
                                final res = await _initSetup(
                                    discountCodeC.text.trim(), true);

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
                      borderRadius: BorderRadius.circular(Sizer.radius(8)),
                    ),
                    child: Column(
                      children: [
                        PlansRowText(
                          keyText: widget.arg?.name ?? '',
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
            Container(
              padding: EdgeInsets.all(Sizer.radius(16)),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.neutral4),
                borderRadius: BorderRadius.circular(Sizer.radius(8)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Details",
                      style: textTheme.text16?.medium,
                    ),
                    YBox(16),
                    CustomTextField(
                      controller: fullNameC,
                      focusNode: fullNameFocus,
                      isRequired: true,
                      labelText: 'Full Name',
                      hintText: 'example',
                      showLabelHeader: true,
                      validator: Validators.required(),
                      onChanged: (v) => setState(() {}),
                    ),
                    YBox(16),
                    CustomTextField(
                      controller: companyNameC,
                      focusNode: companyNameFocus,
                      isRequired: true,
                      labelText: 'Company Name',
                      hintText: 'example',
                      showLabelHeader: true,
                      validator: Validators.required(),
                      onChanged: (v) => setState(() {}),
                    ),
                    YBox(16),
                    CustomTextField(
                      controller: emailC,
                      focusNode: emailFocus,
                      isRequired: true,
                      labelText: 'Email address',
                      hintText: 'example',
                      showLabelHeader: true,
                      validator: Validators.email(),
                      onChanged: (v) => setState(() {}),
                    ),
                    YBox(16),
                    CustomTextField(
                      controller: phoneC,
                      focusNode: phoneFocus,
                      isRequired: true,
                      labelText: 'Phone Number',
                      hintText: 'example',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                      showLabelHeader: true,
                      validator: Validators.phoneNumber(),
                      onChanged: (v) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ),
            YBox(30),
            CustomBtn.solid(
              text: "Continue",
              onTap: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  final res = await subVm.subscribePlan(
                    SubcribePlanParams(
                      name: fullNameC.text.trim(),
                      company: companyNameC.text.trim(),
                      email: emailC.text.trim(),
                      phone: phoneC.text.trim(),
                      priceItemId: widget.arg?.priceItem.id,
                      provider: "paystack",
                      callbackUrl:
                          "${AppConfig.callBackUrl}/auth/register-vendor",
                    ),
                  );

                  printty(res.data.toString());

                  handleApiResponse(
                    response: res,
                    showSuccessToast: false,
                    onSuccess: () {
                      Navigator.pushNamed(
                        context,
                        RoutePath.customWebviewScreen,
                        arguments: WebViewArg(
                          webURL: res.data["data"]["authorization_url"],
                          onSucecess: () {
                            Navigator.pop(context);
                            ModalWrapper.bottomSheet(
                              context: context,
                              canDismiss: false,
                              widget: ConfirmationModal(
                                modalConfirmationArg: ModalConfirmationArg(
                                  iconPath: AppSvgs.checkIcon,
                                  title: "Payment Successful",
                                  description:
                                      "Your subscription to Builder’s konnect is successful. You can now register on the platform to reach more target customers. ",
                                  solidBtnText: "Okay, continue",
                                  onSolidBtnOnTap: () {
                                    final ctx =
                                        NavKey.appNavKey.currentContext!;
                                    Navigator.pop(ctx);
                                    Navigator.pushNamed(
                                      ctx,
                                      RoutePath.subscriptionSuccessScreen,
                                      arguments: SubscriptionSuccessArg(
                                        header: "Subscription Successful!",
                                        content: AppText.subcriptionSuccess,
                                        btnText: "Register as a Vendor",
                                        onTap: () {
                                          Navigator.pushReplacementNamed(
                                            ctx,
                                            RoutePath.vendorRegistrationScreen,
                                            arguments: res.data["data"]
                                                ["reference"],
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
