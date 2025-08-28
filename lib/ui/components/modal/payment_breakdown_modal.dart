import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class PaymentBreakdownModal extends ConsumerStatefulWidget {
  const PaymentBreakdownModal({super.key, required this.paymentMethods});

  final List<PaymentMethodsModel> paymentMethods;

  @override
  ConsumerState<PaymentBreakdownModal> createState() =>
      _PaymentBreakdownModalState();
}

class _PaymentBreakdownModalState extends ConsumerState<PaymentBreakdownModal> {
  late List<TextEditingController> amountCollectedControllers;
  late List<TextEditingController> balanceControllers;
  double totalBalance = 0.0;
  bool get isBalanceZero => totalBalance == 0.0;

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each payment method
    amountCollectedControllers = List.generate(
      widget.paymentMethods.length,
      (index) => TextEditingController(),
    );
    balanceControllers = List.generate(
      widget.paymentMethods.length,
      (index) => TextEditingController(),
    );

    // Add listeners to calculate balance when amount changes
    for (int i = 0; i < amountCollectedControllers.length; i++) {
      amountCollectedControllers[i].addListener(() => _calculateBalance());
    }

    // Initial balance calculation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateBalance();
    });
  }

  @override
  void dispose() {
    for (var controller in amountCollectedControllers) {
      controller.dispose();
    }
    for (var controller in balanceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _calculateBalance() {
    final salesVm = ref.read(salesVmodel);
    final total = salesVm.salesOrderAmountBreakdownModel?.total ?? 0;

    // Calculate total amount collected from all payment methods
    double totalCollected = 0;
    for (var controller in amountCollectedControllers) {
      final amount = double.tryParse(controller.text) ?? 0;
      totalCollected += amount;
    }

    // Calculate remaining balance
    final balance = total - totalCollected;
    totalBalance = balance;

    // Update all balance controllers with the remaining balance
    for (var controller in balanceControllers) {
      controller.text = balance.toStringAsFixed(2);
    }

    // Trigger UI update
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final colorSheme = Theme.of(context).colorScheme;
    final salesVm = ref.watch(salesVmodel);
    return Container(
      height: MediaQuery.of(context).size.height * 0.76,
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          YBox(6),
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(AppSvgs.modalHLine),
          ),
          YBox(16),
          Row(
            children: [
              Text(
                "Payment Breakdown",
                style: textTheme.text16?.medium,
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.close,
                  size: Sizer.width(24),
                ),
              )
            ],
          ),
          YBox(16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: Sizer.width(16),
              vertical: Sizer.height(8),
            ),
            decoration: BoxDecoration(
              color: AppColors.neutral3,
              // borderRadius: BorderRadius.circular(Sizer.radius(6)),
            ),
            child: Column(
              children: [
                Text(
                  "Total Amount",
                  style: textTheme.text12?.copyWith(
                    color: AppColors.neutral7,
                  ),
                ),
                YBox(4),
                Text(
                  "${AppUtils.nairaSymbol}${AppUtils.formatNumber(number: salesVm.salesOrderAmountBreakdownModel?.total ?? 0)}",
                  style: textTheme.text20?.medium.copyWith(
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                YBox(16),
                ...List.generate(
                  widget.paymentMethods.length,
                  (i) => Padding(
                    padding: EdgeInsets.only(bottom: Sizer.height(12)),
                    child: MethodCard(
                      title: widget.paymentMethods[i].name ?? "",
                      amountCollectedC: amountCollectedControllers[i],
                      balanceC: balanceControllers[i],
                    ),
                  ),
                ),
                CustomBtn.solid(
                    text: "Create order",
                    online: isBalanceZero,
                    isLoading: salesVm.busy(createState),
                    onTap: () async {
                      final ctx = NavKey.appNavKey.currentContext!;
                      final res = await ModalWrapper.bottomSheet(
                        context: context,
                        widget: ConfirmationModal(
                          modalConfirmationArg: ModalConfirmationArg(
                            iconPath: AppSvgs.checkIcon,
                            title: "Create Order",
                            description:
                                "Are you sure you want to create order? This order will be \nrecorded and sent for order confirmation.",
                            solidBtnText: "Yes, create order",
                            onSolidBtnOnTap: () {
                              Navigator.pop(ctx, true);
                            },
                          ),
                        ),
                      );
                      if (res == true) {
                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                          Navigator.pop(ctx);
                          _createOrder();
                        }
                      }
                    }),
                YBox(16),
                CustomBtn.solid(
                  text: "No, cancel",
                  isOutline: true,
                  outlineColor: AppColors.neutral5,
                  textStyle: textTheme.text16,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                YBox(30),
              ],
            ),
          )
        ],
      ),
    );
  }

  _createOrder() async {
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

    List<PaymentMethod> paymentMethods = [];
    for (int i = 0; i < widget.paymentMethods.length; i++) {
      PaymentMethod paymentMethod = PaymentMethod(
        id: widget.paymentMethods[i].id,
        amount: double.tryParse(amountCollectedControllers[i].text) ?? 0,
      );
      paymentMethods.add(paymentMethod);
    }

    // Convert product list to line items
    final selectedProducts = saleVm.productList
        .map((product) => LineItemParams(
              productId: product.id,
              quantity: product.quantity,
            ))
        .toList();

    final order = Order(
      customer: customerCred,
      status: "completed",
      salesType: "pos",
      lineItems: selectedProducts,
      paymentMethods: paymentMethods,
    );

    final res = await ref.read(salesVmodel).salesOrderCheckout(
          params: SalesCheckoutParams(
            orders: [order],
          ),
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

            ref.read(salesVmodel).getSalesOverview(stateObjectName: "empty");
            Navigator.of(ctx).pop();

            ModalWrapper.bottomSheet(
              context: ctx,
              // canDismiss: false,
              widget: ConfirmationModal(
                modalConfirmationArg: ModalConfirmationArg(
                  iconPath: AppSvgs.checkIcon,
                  title: "Order Created",
                  description:
                      "A sales order has been created and sent for order confirmation. Kindly confirm this order before releasing the products to the customer.",
                  solidBtnText: "Okay, good",
                  onSolidBtnOnTap: () {
                    // Get navigation context safely
                    final navCtx = NavKey.appNavKey.currentContext;
                    if (navCtx == null) return;

                    // Safely extract orderId from response
                    final dynamic responseData = res.data;
                    if (responseData == null ||
                        responseData['data'] == null ||
                        responseData['data'].isEmpty ||
                        responseData['data'][0]['id'] == null) {
                      printty("Error: Invalid order ID in response");
                      return;
                    }

                    final String orderId = responseData['data'][0]['id'];
                    printty("Response data $orderId");
                    Navigator.pushReplacementNamed(
                        navCtx, RoutePath.viewSalesOrderScreen,
                        arguments: orderId);
                  },
                ),
              ),
            );
          });
        });
  }
}

class MethodCard extends StatelessWidget {
  const MethodCard({
    super.key,
    required this.title,
    required this.amountCollectedC,
    required this.balanceC,
  });

  final String title;
  final TextEditingController amountCollectedC;
  final TextEditingController balanceC;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorSheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(Sizer.radius(16)),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.neutral4,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.text16?.medium,
          ),
          YBox(8),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: amountCollectedC,
                  isRequired: false,
                  labelText: 'Amount Collected',
                  showLabelHeader: true,
                  keyboardType: TextInputType.number,
                  prefixIconConstraints: BoxConstraints(
                    minWidth: Sizer.width(30),
                    minHeight: Sizer.height(30),
                  ),
                  prefixIcon: Container(
                    padding: EdgeInsets.only(
                      left: Sizer.width(12),
                      top: Sizer.height(4),
                    ),
                    child: Text(
                      "₦",
                      style: textTheme.text16?.medium.copyWith(
                        color: colorSheme.black25,
                      ),
                    ),
                  ),
                ),
              ),
              XBox(14),
              Expanded(
                child: CustomTextField(
                  controller: balanceC,
                  isRequired: false,
                  labelText: 'Balance',
                  showLabelHeader: true,
                  readOnly: true,
                  fillColor: AppColors.neutral3,
                  prefixIconConstraints: BoxConstraints(
                    minWidth: Sizer.width(30),
                    minHeight: Sizer.height(30),
                  ),
                  prefixIcon: Container(
                    padding: EdgeInsets.only(
                      left: Sizer.width(12),
                      top: Sizer.height(4),
                    ),
                    child: Text(
                      "₦",
                      style: textTheme.text16?.medium.copyWith(
                        color: colorSheme.black25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
