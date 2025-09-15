import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/services.dart';

class VendorDetails extends ConsumerStatefulWidget {
  final Function()? onNext;
  final String reference;

  const VendorDetails({
    super.key,
    this.onNext,
    required this.reference,
  });

  @override
  ConsumerState<VendorDetails> createState() => _VendorDetailsState();
}

class _VendorDetailsState extends ConsumerState<VendorDetails> {
  final businessNameC = TextEditingController();
  final businessCategoryC = TextEditingController();
  final businessTypeC = TextEditingController();
  final contactNameC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final addressC = TextEditingController();
  final stateC = TextEditingController();
  final cityC = TextEditingController();
  final postalCodeC = TextEditingController();

  final businessNameF = FocusNode();
  final businessCategoryF = FocusNode();
  final businessTypeF = FocusNode();
  final contactNameF = FocusNode();
  final emailF = FocusNode();
  final phoneF = FocusNode();
  final addressF = FocusNode();
  final stateF = FocusNode();
  final cityF = FocusNode();
  final postalCodeF = FocusNode();

  final formKey = GlobalKey<FormState>();

  String? callbackUrl;
  StateModel? selectedState;
  CityModel? selectedCity;
  BusinessCategoryTypeModel? selectedCategory;
  BusinessCategoryTypeModel? selectedType;

  @override
  void dispose() {
    businessNameC.dispose();
    businessCategoryC.dispose();
    businessTypeC.dispose();
    contactNameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    addressC.dispose();
    stateC.dispose();
    cityC.dispose();
    businessNameF.dispose();
    businessCategoryF.dispose();
    businessTypeF.dispose();
    contactNameF.dispose();
    emailF.dispose();
    phoneF.dispose();
    addressF.dispose();
    stateF.dispose();
    cityF.dispose();
    postalCodeF.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confirmPayment();
    });
  }

  Future<void> _confirmPayment() async {
    final res = await ref
        .read(subscriptionVModel)
        .verifySubscription(reference: widget.reference);

    handleApiResponse(
      response: res,
      showSuccessToast: false,
      onSuccess: () {
        emailC.text = res.data?.metadata?.email ?? "";
        phoneC.text = res.data?.metadata?.phone ?? "";
        phoneC.text = res.data?.metadata?.phone ?? "";
        contactNameC.text = res.data?.metadata?.name ?? "";
        businessNameC.text = res.data?.metadata?.company ?? "";
        callbackUrl = res.data?.metadata?.callbackUrl;
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.only(
                top: Sizer.height(30),
                bottom: Sizer.height(60),
              ),
              children: [
                CustomTextField(
                  controller: businessNameC,
                  focusNode: businessNameF,
                  isRequired: true,
                  labelText: 'Business Name',
                  hintText: 'Builer\'sHub',
                  showLabelHeader: true,
                  validator: Validators.required(),
                ),
                YBox(20),
                CustomTextField(
                  controller: businessCategoryC,
                  focusNode: businessCategoryF,
                  isRequired: true,
                  readOnly: true,
                  labelText: 'Business Category',
                  hintText: 'Select category',
                  showLabelHeader: true,
                  validator: Validators.required(),
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: Sizer.radius(20),
                    color: AppColors.neutral7,
                  ),
                  onTap: () async {
                    final res = await ModalWrapper.bottomSheet(
                      context: context,
                      widget: BusinessCategoryTypeModal(),
                    );

                    if (res is BusinessCategoryTypeModel) {
                      businessCategoryC.text = res.name ?? "";
                      selectedCategory = res;
                    }
                  },
                ),
                YBox(20),
                CustomTextField(
                  controller: businessTypeC,
                  focusNode: businessTypeF,
                  isRequired: true,
                  labelText: 'Business Type',
                  hintText: 'Select business type',
                  showLabelHeader: true,
                  readOnly: true,
                  validator: Validators.required(),
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: Sizer.radius(20),
                    color: AppColors.neutral7,
                  ),
                  onTap: () async {
                    final res = await ModalWrapper.bottomSheet(
                      context: context,
                      widget: BusinessCategoryTypeModal(isCategory: false),
                    );
                    if (res is BusinessCategoryTypeModel) {
                      businessTypeC.text = res.name ?? "";
                      selectedType = res;
                    }
                  },
                ),
                YBox(20),
                CustomTextField(
                  controller: contactNameC,
                  focusNode: contactNameF,
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
                        controller: emailC,
                        focusNode: emailF,
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
                        controller: phoneC,
                        focusNode: phoneF,
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
                  controller: addressC,
                  focusNode: addressF,
                  isRequired: true,
                  labelText: 'Business Address',
                  hintText: 'example',
                  showLabelHeader: true,
                  validator: Validators.required(),
                ),
                YBox(20),
                CustomTextField(
                  controller: stateC,
                  focusNode: stateF,
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
                  onTap: () async {
                    final res = await ModalWrapper.bottomSheet(
                      context: context,
                      widget: StateModal(),
                    );
                    if (res is StateModel) {
                      stateC.text = res.name ?? "";
                      selectedState = res;
                    }
                  },
                ),
                YBox(20),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: cityC,
                        focusNode: cityF,
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
                        onTap: () async {
                          if (selectedState == null) {
                            FlushBarToast.fLSnackBar(
                              snackBarType: SnackBarType.warning,
                              message: "Please select state first",
                            );
                            return;
                          }
                          final res = await ModalWrapper.bottomSheet(
                            context: context,
                            widget: CityModal(stateId: selectedState?.id ?? 0),
                          );
                          if (res is CityModel) {
                            cityC.text = res.name ?? "";
                            selectedCity = res;
                          }
                        },
                      ),
                    ),
                    XBox(20),
                    Expanded(
                      child: CustomTextField(
                        controller: postalCodeC,
                        focusNode: postalCodeF,
                        isRequired: false,
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
        ),
        CustomBtn.solid(
          text: "Next",
          onTap: () async {
            if (formKey.currentState!.validate()) {
              final onboardParams = OnboardParams(
                businessName: businessNameC.text.trim(),
                categoryId: selectedCategory?.id,
                businessType: selectedType?.id,
                contactName: contactNameC.text.trim(),
                email: emailC.text.trim(),
                phone: phoneC.text.trim(),
                address: addressC.text.trim(),
                stateId: selectedState?.id ?? 0,
                cityId: selectedCity?.id ?? 0,
                callbackUrl: "${AppConfig.callBackUrl}/auth/create-password",
                providerReference: widget.reference,
                // postalCode: postalCodeC.text.trim(),
              );
              final res = await ref
                  .read(onboardVmodel)
                  .validateMerchantDetails(onboardParams: onboardParams);

              handleApiResponse(
                  response: res,
                  showSuccessToast: false,
                  onSuccess: () {
                    ref
                        .read(onboardVmodel)
                        .setVendorOnboardParams(onboardParams);
                    widget.onNext?.call();
                  });
            }
          },
        ),
      ],
    );
  }
}
