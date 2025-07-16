import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class VendorDetails extends StatefulWidget {
  const VendorDetails({super.key});

  @override
  State<VendorDetails> createState() => _VendorDetailsState();
}

class _VendorDetailsState extends State<VendorDetails> {
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
              YBox(20),
              CustomTextField(
                fieldId: 'contactName',
                fieldType: FieldType.text,
                isRequired: true,
                showIsRequiredIcon: true,
                formController: _formController,
                labelText: 'Contact Name',
                hintText: 'example',
                showLabelHeader: true,
              ),
              YBox(20),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      fieldId: 'email',
                      fieldType: FieldType.email,
                      isRequired: true,
                      showIsRequiredIcon: true,
                      formController: _formController,
                      labelText: 'Email address',
                      hintText: 'example',
                      showLabelHeader: true,
                    ),
                  ),
                  XBox(20),
                  Expanded(
                    child: CustomTextField(
                      fieldId: 'phoneNumber',
                      fieldType: FieldType.phone,
                      isRequired: true,
                      showIsRequiredIcon: true,
                      formController: _formController,
                      labelText: 'Phone Number',
                      hintText: 'example',
                      showLabelHeader: true,
                    ),
                  ),
                ],
              ),
              YBox(20),
              CustomTextField(
                fieldId: 'businessAddress',
                fieldType: FieldType.text,
                isRequired: true,
                showIsRequiredIcon: true,
                formController: _formController,
                labelText: 'Business Address',
                hintText: 'example',
                showLabelHeader: true,
              ),
              YBox(20),
              CustomTextField(
                fieldId: 'state',
                fieldType: FieldType.text,
                isRequired: true,
                showIsRequiredIcon: true,
                formController: _formController,
                labelText: 'State',
                hintText: 'example',
                showLabelHeader: true,
              ),
              YBox(20),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      fieldId: 'city',
                      fieldType: FieldType.text,
                      isRequired: true,
                      showIsRequiredIcon: true,
                      formController: _formController,
                      labelText: 'City/Region',
                      hintText: 'example',
                      showLabelHeader: true,
                    ),
                  ),
                  XBox(20),
                  Expanded(
                    child: CustomTextField(
                      fieldId: 'Street',
                      fieldType: FieldType.text,
                      isRequired: true,
                      showIsRequiredIcon: true,
                      formController: _formController,
                      labelText: 'Postal Code',
                      hintText: 'example',
                      showLabelHeader: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        CustomBtn.solid(
          text: "Next",
          onTap: () {
            _submitForm();
          },
        ),
      ],
    );
  }
}
