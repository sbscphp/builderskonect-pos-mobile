import 'dart:io';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class RequestOtherInfoTab extends ConsumerStatefulWidget {
  const RequestOtherInfoTab({
    super.key,
    this.onPrevious,
  });

  final Function()? onPrevious;

  @override
  ConsumerState<RequestOtherInfoTab> createState() =>
      _RequestOtherInfoTabState();
}

class _RequestOtherInfoTabState extends ConsumerState<RequestOtherInfoTab> {
  final _formKey = GlobalKey<FormState>();
  final shippingWeightTypeC = TextEditingController();
  final shippingClassC = TextEditingController();

  //parcel dimension form
  final lengthC = TextEditingController();
  final widthC = TextEditingController();
  final heightC = TextEditingController();

  File? _docFile;
  String? _docUrl;

  @override
  void dispose() {
    shippingWeightTypeC.dispose();
    shippingClassC.dispose();

    lengthC.dispose();
    widthC.dispose();
    heightC.dispose();

    super.dispose();
  }

  void _handleSubmit() async {
    final ctx = NavKey.appNavKey.currentContext!;
    try {
      final vm = ref.read(productInventoryVmodel);

      // Get current variation params
      final currentParams = vm.variationParams;

      if (currentParams == null) {
        showWarningToast('Please complete the previous steps first');
        return;
      }

      // Collect shipping classes from the form
      final shippingClasses = <String>[];
      if (shippingWeightTypeC.text.trim().isNotEmpty) {
        shippingClasses.add(shippingWeightTypeC.text.trim());
      }
      // if (shippingClassC.text.trim().isNotEmpty) {
      //   shippingClasses.add(shippingClassC.text.trim());
      // }

      // Update the media with document URL if available
      final updatedMedia = currentParams.media?.copyWith(
            productSpecification:
                currentParams.media?.productSpecification ?? '',
            productAdditionalDocument:
                _docUrl ?? currentParams.media?.productAdditionalDocument ?? '',
          ) ??
          ProductVarientMedia(
            productSpecification: '',
            productAdditionalDocument: _docUrl ?? '',
          );

      // Update variants with parcel dimensions if they exist
      final updatedVariants = currentParams.variants?.map((variant) {
        // Create updated physical dimension with parcel dimensions
        final updatedDimension = UnitValue(
          unit: lengthC.text.isNotEmpty
              ? lengthC.text
              : variant.physicalDimension.unit,
          value: int.tryParse(widthC.text) ?? variant.physicalDimension.value,
        );

        return variant.copyWith(
          physicalDimension: updatedDimension,
        );
      }).toList();

      // Create updated variation params with shipping classes and updated media
      final updatedParams = currentParams.copyWith(
        shippingClasses: shippingClasses,
        media: updatedMedia,
        variants: updatedVariants,
      );

      // Set the updated variation parameters
      vm.setVariationParams(updatedParams);

      // Call the API to create multiple variations
      final response = await vm.createMultipleVariation();

      if (response.success) {
        // Show success message
        if (context.mounted) {
          ModalWrapper.bottomSheet(
            context: ctx,
            canDismiss: false,
            widget: ConfirmationModal(
              modalConfirmationArg: ModalConfirmationArg(
                iconPath: AppSvgs.checkIcon,
                title: "Request Submitted Successfully",
                description:
                    "Your request to add this product has been submitted. You will be notified once this has been approved.",
                solidBtnText: "Okay, good",
                onSolidBtnOnTap: () {
                  ref.read(productInventoryVmodel).getInventoryProducts();
                  vm.setSelectedAttributeList([]);
                  Navigator.pop(ctx);
                  Navigator.pop(ctx);
                  Navigator.pop(ctx);
                },
              ),
            ),
          );
        }
      } else {
        // Show error message
        showWarningToast(response.message ?? 'Failed to create product');
      }
    } catch (e) {
      showWarningToast('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final vm = ref.watch(productInventoryVmodel);
    return ListView(
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
            borderRadius: BorderRadius.circular(Sizer.radius(6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Product Documents",
                style: textTheme.text16?.medium,
              ),
              HDivider(),
              UploadWidget(
                documentName: _docFile?.path.split('/').last,
                labelText: "Product Specification Document",
                uploadText:
                    "Click to upload cover Image.                      ",

                // buttomTextDesc: "",
                onUpload: () async {
                  // Reset progress tracking for any previous uploads
                  ref.read(fileUploadVm).resetProgress();

                  final file = await ImageAndDocUtils.pickDocument();
                  if (file != null) {
                    _docFile = file;
                    final r =
                        await ref.read(fileUploadVm).uploadFile(file: [file]);
                    _docUrl = r.data?.first.url;
                  }
                },
              ),
            ],
          ),
        ),
        YBox(16),
        Container(
          padding: EdgeInsets.all(Sizer.radius(16)),
          decoration: BoxDecoration(
            color: colorScheme.white,
            borderRadius: BorderRadius.circular(Sizer.radius(6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Shipping Clasification",
                style: textTheme.text16?.medium,
              ),
              HDivider(),
              CustomTextField(
                controller: shippingWeightTypeC,
                labelText: 'Shipping weight type',
                hintText: 'Select type',
                showLabelHeader: true,
                showSuffixIcon: true,
                readOnly: true,
                onTap: () async {
                  final options = [
                    "Light weight",
                    "Standard weight",
                    'Heavy duty',
                    'Extra heavy duty'
                  ];
                  final res = await ModalWrapper.bottomSheet(
                    context: context,
                    widget: StoreOptionModal(
                      options: options
                          .map((e) => ModalOption(
                              title: e,
                              onTap: () {
                                shippingWeightTypeC.text = e;
                                Navigator.pop(context);
                              }))
                          .toList(),
                    ),
                  );
                },
              ),
              YBox(16),
              CustomTextField(
                controller: shippingClassC,
                labelText: 'Shipping class',
                hintText: 'Select class',
                showLabelHeader: true,
                showSuffixIcon: true,
                readOnly: true,
                onTap: () async {
                  final options = [
                    "light",
                    "standard",
                    'heavy',
                    'oversized',
                    'hazardous',
                    'fragile',
                    'liquid',
                    'special_handling',
                  ];
                  final res = await ModalWrapper.bottomSheet(
                    context: context,
                    widget: StoreOptionModal(
                      options: options
                          .map((e) => ModalOption(
                              title: e,
                              onTap: () {
                                shippingClassC.text = e;
                                Navigator.pop(context);
                              }))
                          .toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        YBox(16),
        Container(
          padding: EdgeInsets.all(Sizer.radius(16)),
          decoration: BoxDecoration(
            color: colorScheme.white,
            borderRadius: BorderRadius.circular(Sizer.radius(6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Parcel Dimension",
                style: textTheme.text16?.medium,
              ),
              HDivider(),
              RichText(
                text: TextSpan(
                  style:
                      textTheme.text14?.copyWith(fontStyle: FontStyle.italic),
                  children: [
                    TextSpan(
                      text:
                          "This should be the dimension of the selling unit selected. E.g Bucket dimension for paints",
                    ),
                  ],
                ),
              ),
              YBox(16),
              CustomTextField(
                controller: lengthC,
                labelText: 'Length',
                hintText: 'Enter value',
                showLabelHeader: true,
                showSuffixIcon: true,
                suffixIcon: InkWell(
                  onTap: () async {
                    final options = [
                      "Millmeters (mm)",
                      "Meters (m)",
                      'Centimeter (cm)',
                    ];
                    final res = await ModalWrapper.bottomSheet(
                      context: context,
                      widget: StoreOptionModal(
                        options: options
                            .map((e) => ModalOption(
                                title: e,
                                onTap: () {
                                  lengthC.text = e.split(' (')[1].split(')')[0];
                                  Navigator.pop(context);
                                }))
                            .toList(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.gray100),
                    padding: EdgeInsets.all(12),
                    child: Text(
                      lengthC.text,
                      style: textTheme.text12,
                    ),
                  ),
                ),
                // readOnly: true,
              ),
              YBox(16),
              CustomTextField(
                controller: widthC,
                labelText: 'Width',
                hintText: 'Enter value',
                showLabelHeader: true,
                showSuffixIcon: true,
                suffixIcon: InkWell(
                  onTap: () async {
                    final options = [
                      "Millmeters (mm)",
                      "Meters (m)",
                      'Centimeter (cm)',
                    ];
                    final res = await ModalWrapper.bottomSheet(
                      context: context,
                      widget: StoreOptionModal(
                        options: options
                            .map((e) => ModalOption(
                                title: e,
                                onTap: () {
                                  widthC.text = e.split(' (')[1].split(')')[0];
                                  Navigator.pop(context);
                                }))
                            .toList(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.gray100),
                    padding: EdgeInsets.all(12),
                    child: Text(
                      widthC.text,
                      style: textTheme.text12,
                    ),
                  ),
                ),
                // readOnly: true,
              ),
              YBox(16),
              CustomTextField(
                controller: heightC,
                labelText: 'Height',
                hintText: 'Enter value',
                showLabelHeader: true,
                showSuffixIcon: true,
                suffixIcon: InkWell(
                  onTap: () async {
                    final options = [
                      "Millmeters (mm)",
                      "Meters (m)",
                      'Centimeter (cm)',
                    ];
                    final res = await ModalWrapper.bottomSheet(
                      context: context,
                      widget: StoreOptionModal(
                        options: options
                            .map((e) => ModalOption(
                                title: e,
                                onTap: () {
                                  heightC.text = e.split(' (')[1].split(')')[0];
                                  Navigator.pop(context);
                                }))
                            .toList(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.gray100),
                    padding: EdgeInsets.all(12),
                    child: Text(
                      heightC.text,
                      style: textTheme.text12,
                    ),
                  ),
                ),
                // readOnly: true,
              ),
              YBox(16),
              vm.busy(createState)
                  ? BtnLoadState()
                  : Row(
                      children: [
                        Expanded(
                          child: CustomBtn.solid(
                            onTap: () {
                              widget.onPrevious?.call();
                            },
                            text: "Back",
                            textColor: Colors.black,
                            onlineColor: Colors.transparent,
                            outlineColor: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: CustomBtn.solid(
                            // onTap: _handleSubmit,
                            onTap: () {
                              ModalWrapper.bottomSheet(
                                context: context,
                                widget: ConfirmationModal(
                                  modalConfirmationArg: ModalConfirmationArg(
                                    iconPath: AppSvgs.infoCircle,
                                    title: "Submit Request",
                                    description:
                                        "Are you sure you want to submit this product to be added to your inventory? Kindly check that all information is correctly filled.",
                                    solidBtnText: "Yes Submit",
                                    onSolidBtnOnTap: () {
                                      Navigator.pop(context);
                                      _handleSubmit();
                                    },
                                    onOutlineBtnOnTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );
                            },
                            text: "Submit",
                          ),
                        )
                      ],
                    )
            ],
          ),
        ),
      ],
    );
  }
}
