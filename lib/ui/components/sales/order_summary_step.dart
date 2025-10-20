import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class OrderSummaryStep extends ConsumerStatefulWidget {
  const OrderSummaryStep({
    super.key,
  });

  @override
  ConsumerState<OrderSummaryStep> createState() => _OrderSummaryStepState();
}

class _OrderSummaryStepState extends ConsumerState<OrderSummaryStep> {
  final discountCodeC = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(salesVmodel).salesAmountBreakdown();
    });
  }

  @override
  void dispose() {
    discountCodeC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final salesVm = ref.watch(salesVmodel);
    return Builder(builder: (context) {
      if (salesVm.busy(createState) || salesVm.busy(pauseSalesState)) {
        return SizerLoader();
      }
      if (salesVm.error(createState)) {
        return ErrorState(
          onPressed: () {
            ref.read(salesVmodel).salesAmountBreakdown();
          },
        );
      }
      return ListView(
        padding: EdgeInsets.only(
          top: Sizer.height(16),
          bottom: Sizer.height(60),
          left: Sizer.width(16),
          right: Sizer.width(16),
        ),
        children: [
          Container(
            padding: EdgeInsets.all(Sizer.radius(16)),
            decoration: BoxDecoration(
              color: colorScheme.white,
              borderRadius: BorderRadius.circular(Sizer.radius(6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 9,
                      child: CustomTextField(
                        controller: discountCodeC,
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
                          // isLoading: subVm.busy(discountState),
                          height: 44,
                          text: "Apply",
                          onTap: () async {
                            if (discountCodeC.text.trim().isNotEmpty) {
                              // final res = await _initSetup(
                              //     discountCodeC.text.trim(), true);

                              // handleApiResponse(
                              //   response: res,
                              //   showSuccessToast: false,
                              // );
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
                        keyText: 'Subtotal',
                        valueText:
                            "${AppUtils.nairaSymbol}${AppUtils.formatNumber(number: salesVm.salesOrderAmountBreakdownModel?.subtotal ?? 0)}",
                      ),
                      YBox(14),
                      PlansRowText(
                        keyText: "Discount",
                        valueText:
                            "${AppUtils.nairaSymbol}${AppUtils.formatNumber(number: salesVm.salesOrderAmountBreakdownModel?.totalDiscount ?? 0)}",
                      ),
                      YBox(14),
                      PlansRowText(
                        keyText: "VAT",
                        valueText:
                            "${AppUtils.nairaSymbol}${AppUtils.formatNumber(number: salesVm.salesOrderAmountBreakdownModel?.fees?.taxAmount ?? 0)}",
                      ),
                      YBox(14),
                      PlansRowText(
                        keyText: "Total Cost",
                        valueText:
                            "${AppUtils.nairaSymbol}${AppUtils.formatNumber(number: salesVm.salesOrderAmountBreakdownModel?.total ?? 0)}",
                        keyTextStyle: textTheme.text16,
                        valueTextStyle: textTheme.text16?.bold.copyWith(
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                YBox(150),
                CustomBtn.solid(
                  text: "Pause Sales",
                  isOutline: true,
                  outlineColor: AppColors.neutral5,
                  textStyle: textTheme.text16,
                  onTap: () async {
                    final res = await ModalWrapper.bottomSheet(
                      context: context,
                      widget: ConfirmationModal(
                        modalConfirmationArg: ModalConfirmationArg(
                          iconPath: AppSvgs.infoCircle,
                          title: "Pause Sales",
                          description:
                              "Are you sure you want to pause this sales? Paused sales can be continued from the sales dashboard.",
                          solidBtnText: "Yes, pause",
                          onSolidBtnOnTap: () {
                            Navigator.pop(context, true);
                          },
                          onOutlineBtnOnTap: () {},
                        ),
                      ),
                    );
                    if (res == true) {
                      if (context.mounted) {
                        await _createPauseSales();
                      }
                    }
                  },
                ),
                YBox(24),
                CustomBtn.solid(
                  text: "Next",
                  onTap: () {
                    ModalWrapper.bottomSheet(
                        context: context, widget: PaymentMethodModal());
                  },
                ),
                YBox(30),
              ],
            ),
          ),
        ],
      );
    });
  }

  Future<void> _createPauseSales() async {
    final saleVm = ref.read(salesVmodel);
    final CustomerCred customerCred = saleVm.selectedCustomerData?.id != null
        ? CustomerCred(
            id: saleVm.selectedCustomerData?.id,
          )
        : CustomerCred(
            id: saleVm.selectedCustomerData?.id,
            name: saleVm.selectedCustomerData?.name,
            phone: saleVm.selectedCustomerData?.phone,
            email: saleVm.selectedCustomerData?.email,
            referralSource: saleVm.selectedCustomerData?.source,
            openedVia: "merchant",
          );

    // Convert product list to line items
    final selectedProducts = saleVm.productList
        .map((product) => LineItemParams(
              productId: product.id,
              quantity: product.quantity,
            ))
        .toList();

    final res = await ref.read(salesVmodel).createOfflineSalesOrder(
      order: Order(
        customer: customerCred,
        status: "draft",
        salesType: "pos",
        lineItems: selectedProducts,
      ),
      metadata: {'order_type': 'paused_sales'},
    );

    handleApiResponse(
        // showErrorToast: false,
        showSuccessToast: false,
        response: res,
        onSuccess: () {
          // Use post-frame callback to ensure the widget tree is stable
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final ctx = NavKey.appNavKey.currentContext;
            if (ctx == null) return;

            // Clear product list and selected customer data
            ref.read(salesVmodel).productList = [];
            ref.read(salesVmodel).selectedCustomerData = null;

            ref.read(salesVmodel).getDraftOverview();
            Navigator.of(ctx).pop();
            Navigator.pushReplacementNamed(ctx, RoutePath.pausedSalesScreen);
          });
        });
  }
}
