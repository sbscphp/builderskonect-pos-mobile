import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class PaymentMethodModal extends ConsumerStatefulWidget {
  const PaymentMethodModal({super.key, this.isPausedSale = false});

  final bool isPausedSale;

  @override
  ConsumerState<PaymentMethodModal> createState() => _PaymentMethodModalState();
}

class _PaymentMethodModalState extends ConsumerState<PaymentMethodModal> {
  List<PaymentMethodsModel> selectedPaymentMethods = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(paymentVmodel).getPaymentMethods();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final paymentVm = ref.watch(paymentVmodel);
    return Container(
      height: MediaQuery.of(context).size.height * 0.62,
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
                "Select Payment Method",
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
          YBox(24),
          Expanded(
            child: LoadableContentBuilder(
                isBusy: paymentVm.isBusy,
                isError: paymentVm.hasError,
                items: paymentVm.paymentMethods,
                loadingBuilder: (p0) {
                  return SizerLoader(height: 300);
                },
                errorBuilder: (p0) {
                  return ErrorState(
                    onPressed: () {
                      paymentVm.getPaymentMethods();
                    },
                  );
                },
                emptyBuilder: (ctx) {
                  return EmptyListState(text: "No data");
                },
                contentBuilder: (ctx) {
                  return ListView(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          bottom: Sizer.height(30),
                        ),
                        itemCount: paymentVm.paymentMethods.length,
                        separatorBuilder: (_, __) {
                          return YBox(12);
                        },
                        itemBuilder: (ctx, i) {
                          final method = paymentVm.paymentMethods[i];
                          return BuildPaymentMethodWidget(
                            title: method.name ?? "",
                            isChecked: selectedPaymentMethods.contains(method),
                            onTap: () {
                              if (selectedPaymentMethods.contains(method)) {
                                selectedPaymentMethods.remove(method);
                              } else {
                                selectedPaymentMethods.add(method);
                              }
                              setState(() {});
                            },
                          );
                        },
                      ),
                      CustomBtn.solid(
                        text: "Next",
                        online: selectedPaymentMethods.isNotEmpty,
                        onTap: () {
                          Navigator.of(context).pop();
                          ModalWrapper.bottomSheet(
                              context: context,
                              widget: PaymentBreakdownModal(
                                isPausedSale: widget.isPausedSale,
                                paymentMethods: selectedPaymentMethods,
                              ));
                        },
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class BuildPaymentMethodWidget extends StatelessWidget {
  const BuildPaymentMethodWidget({
    super.key,
    required this.title,
    this.isChecked = false,
    this.onTap,
  });
  final String title;
  final bool isChecked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Sizer.width(16),
          vertical: Sizer.height(16),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.text6,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CustomCheckbox(
              isSelected: isChecked,
              onTap: onTap,
            ),
            XBox(8),
            Text(
              title,
              style: textTheme.text14?.copyWith(
                color: colorScheme.black85,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
