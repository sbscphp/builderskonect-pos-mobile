// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/services.dart';

class EditBusinessProfileScreen extends ConsumerStatefulWidget {
  const EditBusinessProfileScreen({super.key, required this.business});

  final Business business;

  @override
  ConsumerState<EditBusinessProfileScreen> createState() =>
      _EditBusinessProfileScreenState();
}

class _EditBusinessProfileScreenState
    extends ConsumerState<EditBusinessProfileScreen> {
  final formKey = GlobalKey<FormState>();
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

  StateModel? selectedState;
  CityModel? selectedCity;
  BusinessCategoryTypeModel? selectedCategory;
  BusinessCategoryTypeModel? selectedType;

  // Add these for change detection
  bool _hasChanges = false;
  Map<String, dynamic> _originalValues = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initSetup();
      _setupChangeListeners();
    });
  }

  _initSetup() {
    // Store original values for comparison
    _originalValues = {
      'businessName': widget.business.name ?? '',
      'businessCategory': widget.business.category ?? '',
      'businessType': widget.business.type ?? '',
      'contactName': '',
      'email': widget.business.email ?? '',
      'phone': widget.business.phone ?? '',
      'address': widget.business.address ?? '',
      'state': '',
      'city': '',
      'postalCode': '',
    };

    // Populate controllers
    businessNameC.text = _originalValues['businessName'];
    businessCategoryC.text = _originalValues['businessCategory'];
    businessTypeC.text = _originalValues['businessType'];
    contactNameC.text = _originalValues['contactName'];
    emailC.text = _originalValues['email'];
    phoneC.text = _originalValues['phone'];
    addressC.text = _originalValues['address'];
    stateC.text = _originalValues['state'];
    cityC.text = _originalValues['city'];
    postalCodeC.text = _originalValues['postalCode'];

    // Set selected objects to null since they're not in the Business model
    selectedState = null;
    selectedCity = null;

    setState(() {});
  }

  _setupChangeListeners() {
    // Add listeners to all controllers
    businessNameC.addListener(_checkForChanges);
    contactNameC.addListener(_checkForChanges);
    emailC.addListener(_checkForChanges);
    phoneC.addListener(_checkForChanges);
    addressC.addListener(_checkForChanges);
    postalCodeC.addListener(_checkForChanges);
  }

  _checkForChanges() {
    final currentValues = {
      'businessName': businessNameC.text,
      'businessCategory': businessCategoryC.text,
      'businessType': businessTypeC.text,
      'contactName': contactNameC.text,
      'email': emailC.text,
      'phone': phoneC.text,
      'address': addressC.text,
      'state': stateC.text,
      'city': cityC.text,
      'postalCode': postalCodeC.text,
    };

    bool hasChanges = false;
    for (String key in _originalValues.keys) {
      if (_originalValues[key] != currentValues[key]) {
        hasChanges = true;
        break;
      }
    }

    if (_hasChanges != hasChanges) {
      _hasChanges = hasChanges;
      setState(() {});
    }
  }

  // Update modal selection handlers to trigger change detection
  _onCategorySelected(BusinessCategoryTypeModel category) {
    businessCategoryC.text = category.name ?? "";
    selectedCategory = category;
    _checkForChanges();
  }

  _onTypeSelected(BusinessCategoryTypeModel type) {
    businessTypeC.text = type.name ?? "";
    selectedType = type;
    _checkForChanges();
  }

  _onStateSelected(StateModel state) {
    stateC.text = state.name ?? "";
    selectedState = state;
    cityC.clear();
    selectedCity = null;
    _checkForChanges();
    setState(() {});
  }

  _onCitySelected(CityModel city) {
    cityC.text = city.name ?? "";
    selectedCity = city;
    _checkForChanges();
  }

  @override
  void dispose() {
    // Remove change listeners before disposing controllers
    businessNameC.removeListener(_checkForChanges);
    businessCategoryC.removeListener(_checkForChanges);
    businessTypeC.removeListener(_checkForChanges);
    contactNameC.removeListener(_checkForChanges);
    emailC.removeListener(_checkForChanges);
    phoneC.removeListener(_checkForChanges);
    addressC.removeListener(_checkForChanges);
    stateC.removeListener(_checkForChanges);
    cityC.removeListener(_checkForChanges);
    postalCodeC.removeListener(_checkForChanges);

    // Dispose controllers
    businessNameC.dispose();
    businessCategoryC.dispose();
    businessTypeC.dispose();
    contactNameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    addressC.dispose();
    stateC.dispose();
    cityC.dispose();
    postalCodeC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppbar(
        title: "Edit Business Profile",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: Sizer.width(16),
            right: Sizer.width(16),
            bottom: Sizer.height(50),
          ),
          child: Column(
            children: [
              YBox(16),
              Container(
                padding: EdgeInsets.all(Sizer.radius(16)),
                decoration: BoxDecoration(
                  color: colorScheme.white,
                  borderRadius: BorderRadius.circular(Sizer.radius(4)),
                ),
                child: Form(
                  key: formKey,
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
                        controller: businessNameC,
                        labelText: 'Business Name',
                        hintText: 'Enter business name',
                        showLabelHeader: true,
                        validator: Validators.required(),
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: businessCategoryC,
                        labelText: 'Business Category',
                        hintText: 'Select business category',
                        showLabelHeader: true,
                        readOnly: true,
                        validator: Validators.required(),
                        onTap: () async {
                          final res = await ModalWrapper.bottomSheet(
                            context: context,
                            widget: BusinessCategoryTypeModal(),
                          );

                          if (res is BusinessCategoryTypeModel) {
                            _onCategorySelected(res);
                          }
                        },
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: businessTypeC,
                        labelText: 'Business Type',
                        hintText: 'Select business type',
                        showLabelHeader: true,
                        readOnly: true,
                        validator: Validators.required(),
                        onTap: () async {
                          final res = await ModalWrapper.bottomSheet(
                            context: context,
                            widget:
                                BusinessCategoryTypeModal(isCategory: false),
                          );
                          if (res is BusinessCategoryTypeModel) {
                            _onTypeSelected(res);
                          }
                        },
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: contactNameC,
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
                              isRequired: true,
                              labelText: 'Email address',
                              hintText: 'example',
                              showLabelHeader: true,
                              validator: Validators.email(
                                  errorMessage: "Invalid email"),
                            ),
                          ),
                          XBox(20),
                          Expanded(
                            child: CustomTextField(
                              controller: phoneC,
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
                        isRequired: true,
                        labelText: 'Business Address',
                        hintText: 'example',
                        showLabelHeader: true,
                        validator: Validators.required(),
                      ),
                      YBox(20),
                      CustomTextField(
                        controller: stateC,
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
                            _onStateSelected(res);
                          }
                        },
                      ),
                      YBox(20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: cityC,
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
                                  showWarningToast("Please select state first");
                                  return;
                                }
                                final res = await ModalWrapper.bottomSheet(
                                  context: context,
                                  widget: CityModal(
                                      stateId: selectedState?.id ?? 0),
                                );
                                if (res is CityModel) {
                                  _onCitySelected(res);
                                }
                              },
                            ),
                          ),
                          XBox(20),
                          Expanded(
                            child: CustomTextField(
                              controller: postalCodeC,
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
                        online: _hasChanges,
                        text: "Submit",
                        onTap: _hasChanges
                            ? () {
                                if (formKey.currentState?.validate() == true) {
                                  _submitForm();
                                }
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _submitForm() async {
    final vendorRef = ref.read(vendorProfileVmodel);

    final res = await vendorRef.updateVendorProfile(
      VendorProfileParams(
        name: businessNameC.text,
        category: selectedCategory?.id,
        type: selectedType?.id,

        email: emailC.text,
        phone: phoneC.text,
        address: addressC.text,
        // state: selectedState?.id,
        // city: selectedCity?.id,
        // postalCode: postalCodeC.text,
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
