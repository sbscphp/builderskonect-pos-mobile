import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final CustomFormController _formController = CustomFormController();
  bool isYearly = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
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
                        fieldId: 'businessType',
                        fieldType: FieldType.text,
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
                          bottom: Sizer.height(6),
                        ),
                        child: CustomBtn.solid(
                          height: 40,
                          text: "Apply",
                          onTap: () {},
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
                      RowText(
                        keyText: "Basic Plan",
                        valueText: "N 30,000",
                      ),
                      YBox(14),
                      RowText(
                        keyText: "Discount",
                        valueText: "-",
                      ),
                      YBox(14),
                      RowText(
                        keyText: "VAT",
                        valueText: "N 30,000",
                      ),
                      YBox(14),
                      RowText(
                        keyText: "Total Cost",
                        valueText: "N 30,000",
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
                  "Your Details",
                  style: textTheme.text16?.medium,
                ),
                YBox(16),
                CustomTextField(
                  fieldId: 'fullName',
                  fieldType: FieldType.text,
                  isRequired: true,
                  showIsRequiredIcon: true,
                  formController: _formController,
                  labelText: 'Full Name',
                  hintText: 'example',
                  showLabelHeader: true,
                ),
                YBox(16),
                CustomTextField(
                  fieldId: 'companyName',
                  fieldType: FieldType.text,
                  isRequired: true,
                  showIsRequiredIcon: true,
                  formController: _formController,
                  labelText: 'Company Name',
                  hintText: 'example',
                  showLabelHeader: true,
                ),
                YBox(16),
                CustomTextField(
                  fieldId: 'emailAddress',
                  fieldType: FieldType.text,
                  isRequired: true,
                  showIsRequiredIcon: true,
                  formController: _formController,
                  labelText: 'Email address',
                  hintText: 'example',
                  showLabelHeader: true,
                ),
                YBox(16),
                CustomTextField(
                  fieldId: 'phoneNumber',
                  fieldType: FieldType.text,
                  isRequired: true,
                  showIsRequiredIcon: true,
                  formController: _formController,
                  labelText: 'Phone Number',
                  hintText: 'example',
                  showLabelHeader: true,
                ),
              ],
            ),
          ),
          YBox(30),
          CustomBtn.solid(
            text: "Continue",
            onTap: () {
              ModalWrapper.bottomSheet(
                  context: context,
                  widget: ConfirmationModal(
                    modalConfirmationArg: ModalConfirmationArg(
                      iconPath: AppSvgs.infoCircle,
                      title: "Payment Successful",
                      description:
                          "Your subscription to Builder’skonnect is successful. You can now register on the platform to reach more target customers. ",
                      solidBtnText: "Okay, continue",
                      outlineBtnText: "No, cancel",
                      onSolidBtnOnTap: () {
                        Navigator.pushNamedAndRemoveUntil(context,
                            RoutePath.bottomNavScreen, (route) => false);
                      },
                      onOutlineBtnOnTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ));
            },
          ),
        ],
      ),
    );
  }
}

class RowText extends StatelessWidget {
  const RowText({
    super.key,
    required this.keyText,
    required this.valueText,
    this.keyTextStyle,
    this.valueTextStyle,
  });

  final String keyText;
  final String valueText;

  final TextStyle? keyTextStyle;
  final TextStyle? valueTextStyle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          keyText,
          style: keyTextStyle ??
              textTheme.text14?.copyWith(
                color: colorScheme.black45,
              ),
        ),
        Spacer(),
        Text(
          valueText,
          style: valueTextStyle ??
              textTheme.text14?.medium.copyWith(
                color: colorScheme.black85,
              ),
        ),
      ],
    );
  }
}
