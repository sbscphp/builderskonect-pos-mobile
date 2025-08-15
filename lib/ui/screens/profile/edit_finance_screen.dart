// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

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

  BankModel? selectedBank;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initSetup();
    });
  }

  _initSetup() {
    bankNameC.text = widget.finance.bankName ?? "";
    accountNumberC.text = widget.finance.accountNumber ?? "";
    accountNameC.text = widget.finance.accountName ?? "";

    setState(() {});
  }

  @override
  void dispose() {
    bankNameC.dispose();
    accountNumberC.dispose();
    accountNameC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
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
                  onTsp: () async {
                    final res = await ModalWrapper.bottomSheet(
                        context: context,
                        widget: SelectBankModal(selectedBank: selectedBank));

                    if (res is BankModel) {
                      selectedBank = res;
                      bankNameC.text = res.name ?? "";
                      setState(() {});
                    }
                  },
                ),
                YBox(16),
                CustomTextField(
                  controller: accountNumberC,
                  labelText: 'Account Number',
                  hintText: 'Enter account number',
                  showLabelHeader: true,
                ),
                YBox(16),
                CustomTextField(
                  controller: accountNameC,
                  labelText: 'Account Name',
                  showLabelHeader: true,
                ),
                YBox(30),
                CustomBtn.solid(
                  text: "Submit",
                  onTap: () async {
                    await _submitForm();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _submitForm() async {
    final res = await ref.read(vendorProfileVmodel).updateVendorProfile(
          VendorProfileParams(
            bankName: bankNameC.text.trim(),
            accountNumber: accountNumberC.text.trim(),
            accountName: accountNameC.text.trim(),
          ),
        );

    handleApiResponse(
      response: res,
      onSuccess: () {
        Navigator.pop(context);
      },
    );
  }
}
