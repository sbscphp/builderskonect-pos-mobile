import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/services.dart';

class CustomerDetailsStep extends ConsumerStatefulWidget {
  const CustomerDetailsStep({
    super.key,
    this.onNext,
  });

  final VoidCallback? onNext;

  @override
  ConsumerState<CustomerDetailsStep> createState() =>
      _CustomerDetailsStepState();
}

class _CustomerDetailsStepState extends ConsumerState<CustomerDetailsStep> {
  final formKey = GlobalKey<FormState>();
  final nameC = TextEditingController();
  final phoneC = TextEditingController();
  final emailC = TextEditingController();
  final sourceC = TextEditingController();

  // CustomerData? selectedCustomerData;
  bool showTextField = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      prefillTextFields();
    });
  }

  prefillTextFields() {
    final salesVm = ref.watch(salesVmodel);
    if (salesVm.selectedCustomerData != null) {
      nameC.text = salesVm.selectedCustomerData?.name ?? '';
      phoneC.text = salesVm.selectedCustomerData?.phone ?? '';
      emailC.text = salesVm.selectedCustomerData?.email ?? '';
      sourceC.text = salesVm.selectedCustomerData?.source ?? '';
      showTextField = true;
      setState(() {});
    }
  }

  @override
  void dispose() {
    nameC.dispose();
    phoneC.dispose();
    emailC.dispose();
    sourceC.dispose();

    super.dispose();
  }

  // bool get spaceButton => selectedCustomerData == null && !showTextField;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final salesVm = ref.watch(salesVmodel);
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
              Text("Customer Details", style: textTheme.text16?.medium),
              YBox(8),
              CustomTextField(
                isRequired: false,
                showLabelHeader: false,
                hintText: "Search customer name, id",
                readOnly: true,
                onTap: () async {
                  final res = await ModalWrapper.bottomSheet(
                      context: context, widget: SelectCustomerModal());

                  if (res is CustomerData) {
                    salesVm.selectedCustomerData = res;
                    nameC.text = res.name ?? '';
                    phoneC.text = res.phone ?? '';
                    emailC.text = res.email ?? '';
                    sourceC.text = res.source ?? '';
                  }
                  setState(() {});
                },
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(Sizer.width(10)),
                        decoration: BoxDecoration(),
                        child: SvgPicture.asset(AppSvgs.search),
                      ),
                    ),
                  ],
                ),
              ),
              if (salesVm.selectedCustomerData == null && !showTextField)
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      showTextField = true;
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizer.width(16),
                        vertical: Sizer.height(4),
                      ),
                      margin: EdgeInsets.only(
                        top: Sizer.height(16),
                        bottom: Sizer.height(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(AppSvgs.plus),
                          XBox(10),
                          Text(
                            "Add New Customer",
                            style: textTheme.text14?.copyWith(
                              color: colorScheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (salesVm.selectedCustomerData != null || showTextField)
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      HDivider(verticalPadding: 24),
                      CustomTextField(
                        controller: nameC,
                        isRequired: false,
                        labelText: 'Name',
                        hintText: 'Name',
                        showLabelHeader: true,
                        readOnly: salesVm.selectedCustomerData != null,
                        fillColor: salesVm.selectedCustomerData != null
                            ? AppColors.neutral3
                            : Colors.transparent,
                        validator: Validators.required(),
                      ),
                      YBox(10),
                      CustomTextField(
                        controller: phoneC,
                        isRequired: false,
                        labelText: 'Phone Number',
                        hintText: '0902344333',
                        showLabelHeader: true,
                        readOnly: salesVm.selectedCustomerData?.phone != null,
                        fillColor: salesVm.selectedCustomerData?.phone != null
                            ? AppColors.neutral3
                            : Colors.transparent,
                        validator: Validators.required(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                      ),
                      YBox(10),
                      CustomTextField(
                        controller: emailC,
                        isRequired: false,
                        labelText: 'Email Address',
                        hintText: 'email@example.com',
                        showLabelHeader: true,
                        readOnly: salesVm.selectedCustomerData != null,
                        fillColor: salesVm.selectedCustomerData != null
                            ? AppColors.neutral3
                            : Colors.transparent,
                        validator: Validators.required(),
                      ),
                      YBox(10),
                      CustomTextField(
                        controller: sourceC,
                        isRequired: false,
                        labelText: 'Source',
                        optionalText: "(How did they get to know about you?)",
                        hintText: 'facebook',
                        showLabelHeader: true,
                        readOnly: salesVm.selectedCustomerData != null,
                        fillColor: salesVm.selectedCustomerData != null
                            ? AppColors.neutral3
                            : Colors.transparent,
                        // validator: Validators.required(),
                        onTap: salesVm.selectedCustomerData != null
                            ? null
                            : () async {
                                final res = await ModalWrapper.bottomSheet(
                                    context: context,
                                    widget: SelectSourceModal());

                                if (res is String) {
                                  sourceC.text = res;
                                }
                              },
                      ),
                      if (salesVm.selectedCustomerData != null)
                        InkWell(
                          onTap: () async {
                            final res = await ModalWrapper.bottomSheet(
                              context: context,
                              widget: ConfirmationModal(
                                modalConfirmationArg: ModalConfirmationArg(
                                  iconPath: AppSvgs.infoCircleRed,
                                  title: "Remove Customer",
                                  description:
                                      "Are you sure you want to remove this customer \nfrom the order list? ",
                                  solidBtnText: "Yes, Remove",
                                  onSolidBtnOnTap: () {
                                    Navigator.pop(context, true);
                                  },
                                  outlineBtnText: "No, don’t",
                                  onOutlineBtnOnTap: () {
                                    Navigator.pop(context, false);
                                  },
                                ),
                              ),
                            );
                            if (res == true) {
                              salesVm.selectedCustomerData = null;
                              nameC.clear();
                              phoneC.clear();
                              emailC.clear();
                              sourceC.clear();
                              setState(() {});
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: Sizer.height(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppSvgs.trashOutline,
                                  height: Sizer.height(14),
                                ),
                                XBox(10),
                                Text(
                                  "Remove Customer",
                                  style: textTheme.text14?.copyWith(
                                    color: AppColors.red2D,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      YBox(20),
                    ],
                  ),
                ),
              YBox((salesVm.selectedCustomerData == null && !showTextField)
                  ? 300
                  : 16),
              CustomBtn.solid(
                text: "Next",
                onTap: () {
                  if (salesVm.selectedCustomerData == null && !showTextField) {
                    showWarningToast("Please add customer details");
                    return;
                  }
                  if (formKey.currentState?.validate() == true) {
                    salesVm.selectedCustomerData ??= CustomerData(
                      name: nameC.text.trim(),
                      phone: phoneC.text.trim(),
                      email: emailC.text.trim(),
                      source: sourceC.text.trim(),
                    );

                    widget.onNext?.call();
                  }
                },
              ),
              YBox(10),
            ],
          ),
        ),
      ],
    );
  }
}
