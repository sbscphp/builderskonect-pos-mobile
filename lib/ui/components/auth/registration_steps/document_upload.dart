import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class DocumentUpload extends StatefulWidget {
  const DocumentUpload({super.key});

  @override
  State<DocumentUpload> createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<DocumentUpload> {
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
