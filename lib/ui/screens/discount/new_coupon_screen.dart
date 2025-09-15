import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class NewCouponScreen extends StatefulWidget {
  const NewCouponScreen({super.key});

  @override
  State<NewCouponScreen> createState() => _NewCouponScreenState();
}

class _NewCouponScreenState extends State<NewCouponScreen> {
  final _formKey = GlobalKey<FormState>();
  final fullNameC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final roleC = TextEditingController();
  final assignStoreC = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  DateTime? selectedDate;
  DateTime? endDate;
  bool isCustomdate = false;
  String? selectedLabel;
  dynamic roleId;

  @override
  void dispose() {
    fullNameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    roleC.dispose();
    assignStoreC.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _showCustomDatePicker(BuildContext context) async {
    final result = await showDialog<Map<String, DateTime?>>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizer.radius(16)),
          ),
          child: CustomDatePicker(
            initialDate: selectedDate ?? DateTime.now(),
            endDate: endDate,
            minDate: DateTime.now()
                .subtract(const Duration(days: 365)), // 1 year ago
            maxDate: DateTime.now()
                .add(const Duration(days: 365)), // 1 year from now
            onDateSelected: (startDate, rangeEndDate) {
              Navigator.of(context).pop({
                'startDate': startDate,
                'endDate': rangeEndDate,
              });
            },
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedDate = result['startDate'];
        endDate = result['endDate'];
        isCustomdate = true;
        // Reset the predefined date options when custom date is selected
        selectedLabel = null;

        // Update text controllers
        if (selectedDate != null) {
          _startDateController.text =
              "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
        }
        if (endDate != null) {
          _endDateController.text =
              "${endDate!.day}/${endDate!.month}/${endDate!.year}";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    // final vm = ref.watch(staffVm);
    return BusyOverlay(
      // show: vm.isBusy,
      child: Scaffold(
          appBar: CustomAppbar(
            title: "New Discount",
          ),
          body: Container(
            padding: EdgeInsets.all(Sizer.radius(16)),
            margin: EdgeInsets.only(
              left: Sizer.radius(16),
              right: Sizer.radius(16),
              top: Sizer.radius(16),
            ),
            decoration: BoxDecoration(
              color: colorScheme.white,
              borderRadius: BorderRadius.circular(Sizer.radius(4)),
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text("Add New Coupon", style: textTheme.text16?.medium),
                  Text(
                    "Fill the form below to add a new coupon",
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: roleC,
                    isRequired: false,
                    labelText: 'Coupon Application',
                    // optionalText: "(optional)",
                    hintText: 'Select coupon application',
                    showLabelHeader: true,
                    readOnly: true,
                    showSuffixIcon: true,
                    validator: Validators.required(),
                    onTsp: () async {
                      final res = await ModalWrapper.bottomSheet(
                        context: context,
                        widget: RoleModal(),
                      );
                      if (res is RoleModel) {
                        roleId = res.id;
                        roleC.text = res.name ?? '';
                        setState(() {});
                      }
                    },
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: fullNameC,
                    isRequired: false,
                    labelText: 'Name',
                    hintText: 'Enter coupon name',
                    showLabelHeader: true,
                    validator: Validators.required(),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: fullNameC,
                    isRequired: false,
                    labelText: 'Code',
                    hintText: 'Enter coupon code',
                    showLabelHeader: true,
                    validator: Validators.required(),
                  ),
                  YBox(16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _startDateController,
                          labelText: 'Start Date',
                          hintText: 'Enter Date',
                          showLabelHeader: true,
                          isRequired: false,
                          readOnly: true,
                          onTsp: () async {
                            await _showCustomDatePicker(context);
                          },
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(
                              right: Sizer.radius(10),
                              left: Sizer.radius(4),
                            ),
                            child: SvgPicture.asset(AppSvgs.inputSuffix),
                          ),
                        ),
                      ),
                      XBox(16),
                      Expanded(
                        child: CustomTextField(
                          controller: _endDateController,
                          labelText: 'End Date',
                          hintText: 'Enter Date',
                          showLabelHeader: true,
                          isRequired: false,
                          readOnly: true,
                          onTsp: () async {
                            await _showCustomDatePicker(context);
                          },
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(
                              right: Sizer.radius(10),
                              left: Sizer.radius(4),
                            ),
                            child: SvgPicture.asset(AppSvgs.inputSuffix),
                          ),
                        ),
                      ),
                    ],
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: roleC,
                    isRequired: false,
                    labelText: 'Coupon Type',
                    // optionalText: "(optional)",
                    hintText: 'Select coupon type',
                    showLabelHeader: true,
                    readOnly: true,
                    showSuffixIcon: true,
                    validator: Validators.required(),
                    onTsp: () async {
                      final res = await ModalWrapper.bottomSheet(
                        context: context,
                        widget: RoleModal(),
                      );
                      if (res is RoleModel) {
                        roleId = res.id;
                        roleC.text = res.name ?? '';
                        setState(() {});
                      }
                    },
                  ),
                  YBox(32),
                  CustomBtn.solid(
                    text: "Save",
                    onTap: () async {
                      // ModalWrapper.bottomSheet(
                      //     context: context,
                      //     widget: ConfirmationModal(
                      //         modalConfirmationArg: ModalConfirmationArg(
                      //       iconPath: AppSvgs.infoCircle,
                      //       title: "Create Discount",
                      //       description:
                      //           "Are you sure you want t create this discount? The discounts is autimativally attached to the product",
                      //       solidBtnText: "Yes, create",
                      //       outlineBtnText: "No, cancel",
                      //       onOutlineBtnOnTap: () {
                      //         Navigator.pop(context);
                      //       },
                      //       onSolidBtnOnTap: () async {
                      //         Navigator.pop(context);

                      //         // final res = await vm.updateStaff(isActive: 0);

                      //         // handleApiResponse(response: res);
                      //       },
                      //     )));
                      if (_formKey.currentState?.validate() == true) {
                        // final res = await vm.addNewStaff(
                        //     fullName: fullNameC.text,
                        //     email: emailC.text,
                        //     phone: phoneC.text,
                        //     roleId: roleId);

                        // handleApiResponse(
                        //   response: res,
                        //   onSuccess: () {
                        //     ModalWrapper.bottomSheet(
                        //       context: context,
                        //       canDismiss: false,
                        //       widget: ConfirmationModal(
                        //         modalConfirmationArg: ModalConfirmationArg(
                        //           iconPath: AppSvgs.checkIcon,
                        //           title: "Staff Invite Sent Successfully",
                        //           description:
                        //               "An invite has been sent to this user to join Builder’sKonnect. The user will be required to create their own password to Login.",
                        //           solidBtnText: "Okay, Good",
                        //           onSolidBtnOnTap: () {
                        //             Navigator.pop(context);
                        //             Navigator.pop(context);
                        //           },
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // );
                      }
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
