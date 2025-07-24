import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class BankDetails extends ConsumerStatefulWidget {
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const BankDetails({
    super.key,
    this.onNext,
    this.onPrevious,
  });

  @override
  ConsumerState<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends ConsumerState<BankDetails> {
  final formKey = GlobalKey<FormState>();

  final bankC = TextEditingController();
  final accountNumberC = TextEditingController();
  final accountNameC = TextEditingController();

  final bankF = FocusNode();
  final accountNumberF = FocusNode();
  final accountNameF = FocusNode();

  BankModel? selectedBank;

  @override
  void dispose() {
    bankC.dispose();
    accountNumberC.dispose();
    accountNameC.dispose();
    formKey.currentState?.dispose();
    bankF.dispose();
    accountNumberF.dispose();
    accountNameF.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bankVm = ref.watch(bankVmodel);
    return Column(
      children: [
        Expanded(
          child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.only(
                top: Sizer.height(30),
                bottom: Sizer.height(60),
              ),
              children: [
                CustomTextField(
                  controller: bankC,
                  focusNode: bankF,
                  isRequired: true,
                  labelText: 'Bank Name',
                  hintText: 'Select bank name',
                  readOnly: true,
                  showLabelHeader: true,
                  validator: Validators.required(),
                  onChanged: (v) => setState(() {}),
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: AppColors.neutral9,
                  ),
                  onTsp: () async {
                    final res = await ModalWrapper.bottomSheet(
                        context: context,
                        widget: SelectBankModal(selectedBank: selectedBank));

                    if (res is BankModel) {
                      selectedBank = res;
                      bankC.text = res.name ?? "";
                      setState(() {});
                    }
                  },
                ),
                YBox(20),
                CustomTextField(
                  controller: accountNumberC,
                  focusNode: accountNumberF,
                  isRequired: true,
                  labelText: 'Account Number',
                  hintText: 'Enter account number',
                  showLabelHeader: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  readOnly: selectedBank == null,
                  onTsp: () {
                    if (selectedBank == null) {
                      return FlushBarToast.fLSnackBar(
                        snackBarType: SnackBarType.warning,
                        message: 'Please select bank name',
                      );
                    }
                  },
                  validator: Validators.required(),
                  onChanged: (v) async {
                    if (v.trim().length == 10) {
                      final res = await ref.read(bankVmodel).verifyBank(
                            accountNumber: v.trim(),
                            bankId: selectedBank?.id ?? 0,
                          );
                      handleApiResponse(
                        response: res,
                        showSuccessToast: false,
                        onSuccess: () {
                          accountNameC.text = res.data ?? "";
                        },
                      );
                    }
                  },
                ),
                YBox(20),
                CustomTextField(
                  controller: accountNameC,
                  focusNode: accountNameF,
                  isRequired: true,
                  readOnly: true,
                  labelText: 'Account Name',
                  hintText: 'Enter account name',
                  showLabelHeader: true,
                  fillColor: AppColors.neutral3,
                  validator: Validators.required(),
                  suffixIcon: bankVm.busy(verifyBankState)
                      ? Padding(
                          padding: EdgeInsets.only(right: Sizer.width(4)),
                          child: CupertinoActivityIndicator(),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CustomBtn.solid(
                isOutline: true,
                outlineColor: AppColors.neutral5,
                textStyle: textTheme.text16,
                text: "Previous",
                onTap: widget.onPrevious,
              ),
            ),
            XBox(20),
            Expanded(
              child: CustomBtn.solid(
                  text: "Next",
                  onTap: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      final params = OnboardParams(
                        bankId: selectedBank?.id ?? 0,
                        accountNumber: accountNumberC.text.trim(),
                        accountName: accountNameC.text.trim(),
                      );

                      final res = await ref
                          .read(onboardVmodel)
                          .validateBank(onboardParams: params);

                      handleApiResponse(
                        response: res,
                        showSuccessToast: false,
                        onSuccess: () {
                          ref.read(onboardVmodel).setBankOnboardParams(params);
                          widget.onNext?.call();
                        },
                      );
                    }
                  }),
            ),
          ],
        ),
        YBox(10),
      ],
    );
  }
}
