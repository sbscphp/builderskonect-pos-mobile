// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/services.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: CustomAppbar(
          title: "Edit",
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
                  Text("Business Profile", style: textTheme.text16?.medium),
                  Text(
                    "Edit information and submit for approval",
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                  YBox(16),
                  CustomTextField(
                    // controller: tinC,
                    // focusNode: tinF,
                    labelText: 'Business Name',
                    hintText: 'Enter business name',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    // controller: tinC,
                    // focusNode: tinF,
                    labelText: 'Business Category',
                    hintText: 'Select business category',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    // controller: tinC,
                    // focusNode: tinF,
                    labelText: 'Business Type',
                    hintText: 'Select business type',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    // controller: contactNameC,
                    // focusNode: contactNameF,
                    isRequired: true,
                    labelText: 'Contact Name',
                    hintText: 'example',
                    showLabelHeader: true,
                    validator: Validators.required(),
                  ),
                  YBox(20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          // controller: emailC,
                          // focusNode: emailF,
                          isRequired: true,
                          labelText: 'Email address',
                          hintText: 'example',
                          showLabelHeader: true,
                          validator: Validators.email(),
                        ),
                      ),
                      XBox(20),
                      Expanded(
                        child: CustomTextField(
                          // controller: phoneC,
                          // focusNode: phoneF,
                          isRequired: true,
                          labelText: 'Phone Number',
                          hintText: 'example',
                          showLabelHeader: true,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                          validator: Validators.phoneNumber(),
                        ),
                      ),
                    ],
                  ),
                  YBox(20),
                  CustomTextField(
                    // controller: addressC,
                    // focusNode: addressF,
                    isRequired: true,
                    labelText: 'Business Address',
                    hintText: 'example',
                    showLabelHeader: true,
                    validator: Validators.required(),
                  ),
                  YBox(20),
                  CustomTextField(
                    // controller: stateC,
                    // focusNode: stateF,
                    isRequired: true,
                    labelText: 'State',
                    hintText: 'example',
                    showLabelHeader: true,
                    readOnly: true,
                    validator: Validators.required(),
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: Sizer.radius(20),
                      color: AppColors.neutral7,
                    ),
                    onTsp: () async {
                      // final res = await ModalWrapper.bottomSheet(
                      //   context: context,
                      //   widget: StateModal(),
                      // );
                      // if (res is StateModel) {
                      //   stateC.text = res.name ?? "";
                      //   selectedState = res;
                      // }
                    },
                  ),
                  YBox(20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          // controller: cityC,
                          // focusNode: cityF,
                          isRequired: true,
                          labelText: 'City/Region',
                          hintText: 'example',
                          showLabelHeader: true,
                          readOnly: true,
                          validator: Validators.required(),
                          suffixIcon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: Sizer.radius(20),
                            color: AppColors.neutral7,
                          ),
                          onTsp: () async {
                            // if (selectedState == null) {
                            //   FlushBarToast.fLSnackBar(
                            //     snackBarType: SnackBarType.warning,
                            //     message: "Please select state first",
                            //   );
                            //   return;
                            // }
                            // final res = await ModalWrapper.bottomSheet(
                            //   context: context,
                            //   widget: CityModal(stateId: selectedState?.id ?? 0),
                            // );
                            // if (res is CityModel) {
                            //   cityC.text = res.name ?? "";
                            //   selectedCity = res;
                            // }
                          },
                        ),
                      ),
                      XBox(20),
                      Expanded(
                        child: CustomTextField(
                          // controller: postalCodeC,
                          // focusNode: postalCodeF,
                          isRequired: false,
                          labelText: 'Postal Code',
                          hintText: 'example',
                          showLabelHeader: true,
                        ),
                      ),
                    ],
                  ),
                  YBox(30),
                  CustomBtn.solid(
                    text: "Submit",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
