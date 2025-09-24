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
  // final _formKey = GlobalKey<FormState>();
  final productNameC = TextEditingController();
  final brandC = TextEditingController();

  File? _docFile;
  String? _docUrl;

  @override
  void dispose() {
    productNameC.dispose();
    brandC.dispose();

    super.dispose();
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
                controller: vm.shippingWeightTypeC,
                labelText: 'Shipping weight type',
                hintText: 'Select type',
                showLabelHeader: true,
                showSuffixIcon: true,
                readOnly: true,
                onTap: () async {
                  final options = ["Light", "Standard", 'Heavy', 'Oversized'];
                  final res = await ModalWrapper.bottomSheet(
                    context: context,
                    widget: StoreOptionModal(
                      options: options
                          .map((e) => ModalOption(
                              title: e,
                              onTap: () {
                                vm.shippingWeightTypeC.text = e;
                                Navigator.pop(context);
                              }))
                          .toList(),
                    ),
                  );
                },
              ),
              YBox(16),
              CustomTextField(
                controller: vm.shippingClassC,
                labelText: 'Shipping class',
                hintText: 'Select class',
                showLabelHeader: true,
                showSuffixIcon: true,
                readOnly: true,
                onTap: () async {
                  final options = [
                    "Fragile",
                    "Harzardous",
                    'Liquid',
                    'Special handling'
                  ];
                  final res = await ModalWrapper.bottomSheet(
                    context: context,
                    widget: StoreOptionModal(
                      options: options
                          .map((e) => ModalOption(
                              title: e,
                              onTap: () {
                                vm.shippingClassC.text = e;
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
                controller: vm.lengthC,
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
                                  vm.lengthUnit =
                                      e.split(' (')[1].split(')')[0];
                                  vm.updateUI();
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
                      vm.lengthUnit,
                      style: textTheme.text12,
                    ),
                  ),
                ),
                // readOnly: true,
              ),
              YBox(16),
              CustomTextField(
                controller: vm.widthC,
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
                                  vm.widthUnit = e.split(' (')[1].split(')')[0];
                                  vm.updateUI();
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
                      vm.widthUnit,
                      style: textTheme.text12,
                    ),
                  ),
                ),
                // readOnly: true,
              ),
              YBox(16),
              CustomTextField(
                controller: vm.heigthC,
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
                                  vm.heightUnit =
                                      e.split(' (')[1].split(')')[0];
                                  vm.updateUI();
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
                      vm.heightUnit,
                      style: textTheme.text12,
                    ),
                  ),
                ),
                // readOnly: true,
              ),
            ],
          ),
        ),
        YBox(16),
        Row(
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
                onTap: () {
                  // widget.onNext?.call();
                },
                text: "Submit",
              ),
            )
          ],
        )
      ],
    );
  }
}
