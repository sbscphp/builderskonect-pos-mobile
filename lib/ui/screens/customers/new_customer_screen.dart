// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/services.dart';

class NewCustomerScreen extends ConsumerStatefulWidget {
  const NewCustomerScreen({super.key});

  @override
  ConsumerState<NewCustomerScreen> createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends ConsumerState<NewCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final fullNameC = TextEditingController();
  final phoneC = TextEditingController();
  final emailC = TextEditingController();
  final addressC = TextEditingController();
  final sourceC = TextEditingController();

  @override
  void dispose() {
    fullNameC.dispose();
    phoneC.dispose();
    emailC.dispose();
    addressC.dispose();
    sourceC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BusyOverlay(
      show: ref.watch(customerVmodel).busy(createState),
      child: Scaffold(
          appBar: CustomAppbar(
            title: "New Customer",
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
                  Text("New Customer", style: textTheme.text16?.medium),
                  Text(
                    "Fill the form below to add a new customer",
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: fullNameC,
                    isRequired: false,
                    labelText: 'Full Name',
                    hintText: 'Full Name',
                    showLabelHeader: true,
                    validator: Validators.required(),
                  ),
                  YBox(10),
                  CustomTextField(
                    controller: emailC,
                    isRequired: false,
                    labelText: 'Email Address',
                    hintText: 'email@example.com',
                    showLabelHeader: true,
                    validator: Validators.required(),
                  ),
                  YBox(10),
                  CustomTextField(
                    controller: phoneC,
                    isRequired: false,
                    labelText: 'Phone Number',
                    hintText: '0902344333',
                    showLabelHeader: true,
                    validator: Validators.required(),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                  ),
                  YBox(10),
                  CustomTextField(
                    controller: addressC,
                    isRequired: false,
                    labelText: 'Address',
                    optionalText: "(optional)",
                    hintText: '123 Main St',
                    showLabelHeader: true,
                  ),
                  YBox(10),
                  CustomTextField(
                    controller: sourceC,
                    isRequired: false,
                    labelText: 'Source',
                    optionalText: "(optional)",
                    hintText: 'facebook',
                    showLabelHeader: true,
                    readOnly: true,
                    // validator: Validators.required(),
                    onTap: () async {
                      final res = await ModalWrapper.bottomSheet(
                          context: context, widget: SelectSourceModal());

                      if (res is String) {
                        sourceC.text = res;
                      }
                    },
                  ),
                  YBox(20),
                  CustomBtn.solid(
                    text: "Save",
                    onTap: () async {
                      if (_formKey.currentState?.validate() == true) {
                        final res =
                            await ref.read(customerVmodel).createCustomers(
                                  name: fullNameC.text,
                                  email: emailC.text,
                                  phone: phoneC.text,
                                  address: addressC.text,
                                  source: sourceC.text,
                                );

                        handleApiResponse(
                          response: res,
                          onSuccess: () {
                            Navigator.pop(context);
                            ref.read(customerVmodel).getCustomerOverview();
                          },
                        );
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
