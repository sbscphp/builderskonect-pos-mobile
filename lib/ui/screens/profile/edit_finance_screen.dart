// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class EditFinanceScreen extends ConsumerStatefulWidget {
  const EditFinanceScreen({
    super.key,
    required this.finance,
  });

  final Finance finance;

  @override
  ConsumerState<EditFinanceScreen> createState() => _EditFinanceScreenState();
}

class _EditFinanceScreenState extends ConsumerState<EditFinanceScreen> {
  final bankNameC = TextEditingController();
  final accountNumberC = TextEditingController();
  final accountNameC = TextEditingController();

  int? selectedBankId;

  // Track original values and changes
  Map<String, dynamic> _originalValues = {};
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initSetup();
      _setupChangeListeners();
    });
  }

  _initSetup() {
    // Store originals
    _originalValues = {
      'bankName': widget.finance.bankName ?? "",
      'accountNumber': widget.finance.accountNumber ?? "",
      'accountName': widget.finance.accountName ?? "",
      'bankId': widget.finance.bankId,
    };

    bankNameC.text = _originalValues['bankName'];
    accountNumberC.text = _originalValues['accountNumber'];
    accountNameC.text = _originalValues['accountName'];
    selectedBankId = _originalValues['bankId'];

    setState(() {});
  }

  void _setupChangeListeners() {
    bankNameC.addListener(_checkForChanges);
    accountNumberC.addListener(_checkForChanges);
    accountNameC.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    final currentValues = {
      'bankName': bankNameC.text,
      'accountNumber': accountNumberC.text,
      'accountName': accountNameC.text,
      'bankId': selectedBankId,
    };

    bool changed = false;
    for (final k in _originalValues.keys) {
      if (_originalValues[k] != currentValues[k]) {
        changed = true;
        break;
      }
    }
    if (_hasChanges != changed) {
      setState(() {
        _hasChanges = changed;
      });
    }
  }

  @override
  void dispose() {
    bankNameC.removeListener(_checkForChanges);
    accountNumberC.removeListener(_checkForChanges);
    accountNameC.removeListener(_checkForChanges);
    bankNameC.dispose();
    accountNumberC.dispose();
    accountNameC.dispose();
    super.dispose();
  }

  bool get activateButton {
    return bankNameC.text.trim().isNotEmpty &&
        accountNumberC.text.trim().isNotEmpty &&
        accountNameC.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final profileVm = ref.watch(vendorProfileVmodel);
    final bankVm = ref.watch(bankVmodel);
    return BusyOverlay(
      show: profileVm.busy(updateState),
      child: Scaffold(
        appBar: CustomAppbar(
          title: "Edit Request",
        ),
        body: ListView(
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
                color: colorScheme.white,
                borderRadius: BorderRadius.circular(Sizer.radius(4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Finance", style: textTheme.text16?.medium),
                  Text(
                    "Edit information and submit for approval",
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: bankNameC,
                    labelText: 'Bank Name',
                    hintText: 'Select bank name',
                    showLabelHeader: true,
                    showSuffixIcon: true,
                    readOnly: true,
                    onTap: () async {
                      final res = await ModalWrapper.bottomSheet(
                          context: context, widget: SelectBankModal());

                      if (res is BankModel) {
                        selectedBankId = res.id;
                        bankNameC.text = res.name ?? "";

                        if (accountNumberC.text.trim().isNotEmpty) {
                          final res = await ref.read(bankVmodel).verifyBank(
                                accountNumber: accountNumberC.text.trim(),
                                bankId: selectedBankId ?? 0,
                              );
                          handleApiResponse(
                            response: res,
                            showSuccessToast: false,
                            onSuccess: () {
                              accountNameC.text = res.data ?? "";
                            },
                            onError: () {
                              accountNameC.clear();
                            },
                          );
                        }
                        setState(() {});
                        _checkForChanges();
                      }
                    },
                  ),
                  YBox(16),
                  CustomTextField(
                      controller: accountNumberC,
                      labelText: 'Account Number',
                      hintText: 'Enter account number',
                      showLabelHeader: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      onTap: () {
                        if (selectedBankId == null) {
                          return FlushBarToast.fLSnackBar(
                            snackBarType: SnackBarType.warning,
                            message: 'Please select bank',
                          );
                        }
                      },
                      validator: Validators.required(),
                      onChanged: (v) async {
                        if (v.trim().length == 10) {
                          final res = await ref.read(bankVmodel).verifyBank(
                                accountNumber: v.trim(),
                                bankId: selectedBankId ?? 0,
                              );
                          handleApiResponse(
                            response: res,
                            showSuccessToast: false,
                            onSuccess: () {
                              accountNameC.text = res.data ?? "";
                              _checkForChanges();
                            },
                            onError: () {
                              accountNameC.clear();
                              _checkForChanges();
                            },
                          );
                        }
                        _checkForChanges();
                      }),
                  YBox(16),
                  CustomTextField(
                    controller: accountNameC,
                    labelText: 'Account Name',
                    showLabelHeader: true,
                    readOnly: true,
                    fillColor: AppColors.neutral3,
                    validator: Validators.required(),
                    suffixIcon: bankVm.busy(verifyBankState)
                        ? Padding(
                            padding: EdgeInsets.only(right: Sizer.width(4)),
                            child: CupertinoActivityIndicator(),
                          )
                        : null,
                  ),
                  YBox(30),
                  CustomBtn.solid(
                    text: "Submit",
                    online: activateButton && _hasChanges,
                    onTap: () async {
                      await _submitForm();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _submitForm() async {
    final params = VendorProfileParams(
      bankName: _originalValues['bankName'] != bankNameC.text.trim()
          ? bankNameC.text.trim()
          : null,
      bankId: _originalValues['bankId'] != selectedBankId
          ? selectedBankId?.toString()
          : null,
      accountNumber:
          _originalValues['accountNumber'] != accountNumberC.text.trim()
              ? accountNumberC.text.trim()
              : null,
      accountName: _originalValues['accountName'] != accountNameC.text.trim()
          ? accountNameC.text.trim()
          : null,
    );

    final res = await ref.read(vendorProfileVmodel).updateVendorProfile(params);

    handleApiResponse(
      response: res,
      onSuccess: () {
        Navigator.pop(context);
        ref.read(vendorProfileVmodel).getVendorProfile();
      },
    );
  }
}
