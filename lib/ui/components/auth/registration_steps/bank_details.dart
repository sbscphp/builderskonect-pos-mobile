import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({super.key});

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  final CustomFormController _formController = CustomFormController();

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formController.validateAllFields()) {
      // Get all field values
      final values = _formController.getFieldValues();
      printty('Email: ${values['email']}');
      printty('Password: ${values['password']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(
              top: Sizer.height(30),
              bottom: Sizer.height(60),
            ),
            children: [
              CustomTextField(
                fieldId: 'businessName',
                fieldType: FieldType.text,
                isRequired: true,
                showIsRequiredIcon: true,
                formController: _formController,
                labelText: 'Business Name',
                hintText: 'Builer\'sHub',
                showLabelHeader: true,
              ),
              YBox(20),
              CustomTextField(
                fieldId: 'businessCategory',
                fieldType: FieldType.text,
                isRequired: true,
                showIsRequiredIcon: true,
                formController: _formController,
                labelText: 'Business Category',
                hintText: 'example',
                showLabelHeader: true,
              ),
              YBox(20),
              CustomTextField(
                fieldId: 'businessType',
                fieldType: FieldType.text,
                isRequired: true,
                showIsRequiredIcon: true,
                formController: _formController,
                labelText: 'Business Type',
                hintText: 'example',
                showLabelHeader: true,
              ),
            ],
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
                onTap: () {
                  _submitForm();
                },
              ),
            ),
            XBox(20),
            Expanded(
              child: CustomBtn.solid(
                text: "Next",
                onTap: () {
                  _submitForm();
                },
              ),
            ),
          ],
        ),
        YBox(10),
      ],
    );
  }
}
