import 'dart:io';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class RequestAttributeVarientTab extends ConsumerStatefulWidget {
  const RequestAttributeVarientTab({
    super.key,
    this.onNext,
    this.onPrevious,
  });

  final Function()? onNext;
  final Function()? onPrevious;

  @override
  ConsumerState<RequestAttributeVarientTab> createState() =>
      _RequestAttributeVarientTabState();
}

class _RequestAttributeVarientTabState
    extends ConsumerState<RequestAttributeVarientTab> {
  bool isViewInventoryInformation = false;
  bool isViewPricingInformation = false;

  File? _docFile;
  String? _docUrl;

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
              FilterHeader(
                title: "Product Attributes",
                subTitle: "Select attributes you want to add to this product",
              ),
              YBox(40),
              CustomBtn(
                text: "Add attributes",
                isOutline: true,
                textColor: colorScheme.black85,
                onTap: () async {
                  await ModalWrapper.bottomSheet(
                    context: context,
                    widget: AddAttributeModal(),
                  );
                },
              ),
              YBox(16),
              vm.selectedAttributeList.isNotEmpty
                  ? Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: vm.selectedAttributeList
                          .map(
                            (e) => TagWidget(
                              tag: e.attribute ?? '',
                              onClose: () {
                                vm.selectedAttributeList.remove(e);
                                vm.updateUI();
                              },
                              showCloseIcon: true,
                              tagColor: TagColor(
                                bgColor: AppColors.greenED,
                                borderColor: AppColors.green8F,
                                textColor: AppColors.green1A,
                              ),
                            ),
                          )
                          .toList(),
                    )
                  : SizedBox.shrink(),
              if (vm.selectedAttributeList.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HDivider(),
                    YBox(8),
                    Text(
                      "Does this product have variants?",
                      style: textTheme.text14?.medium,
                    ),
                    YBox(10),
                    Row(
                      children: [
                        Row(
                          children: [
                            CustomRadioBtn(
                              isSelected: vm.hasVariant == true,
                              onTap: () {
                                vm.hasVariant = true;
                                setState(() {});
                              },
                            ),
                            XBox(8),
                            Text(
                              "Yes",
                              style: textTheme.text14?.medium,
                            ),
                          ],
                        ),
                        XBox(40),
                        Row(
                          children: [
                            CustomRadioBtn(
                              isSelected: vm.hasVariant == false,
                              onTap: () {
                                vm.hasVariant = false;
                                setState(() {});
                              },
                            ),
                            XBox(8),
                            Text(
                              "No",
                              style: textTheme.text14?.medium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              // CustomBtn.solid(
              //   text: "Next",
              //   onTap: () {},
              // ),
            ],
          ),
        ),
        YBox(16),
        if (vm.selectedAttributeList.isNotEmpty)
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
                  "${vm.hasVariant == true ? 'Common' : 'Product'} Attributes",
                  style: textTheme.text16?.medium,
                ),
                HDivider(),
                RichText(
                  text: TextSpan(
                    style: textTheme.text14,
                    children: [
                      TextSpan(
                        text: "All asterisk (",
                      ),
                      TextSpan(
                        text: "*",
                        style: textTheme.text14?.medium.copyWith(
                          color: Colors.red,
                        ),
                      ),
                      TextSpan(
                        text: ") are required fields",
                      ),
                    ],
                  ),
                ),
                YBox(16),
                ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      final attribute = vm.selectedAttributeList[index];
                      final ctrs = [];
                      for (var i = 0;
                          i < vm.selectedAttributeList.length;
                          i++) {
                        if (index >= ctrs.length) {
                          ctrs.add(TextEditingController());
                        }
                      }

                      return CustomTextField(
                        controller: ctrs[index],
                        labelText: attribute.attribute ?? '',
                        hintText: 'Select option',
                        showLabelHeader: true,
                        showSuffixIcon: true,
                        readOnly: true,
                        onTap: () async {
                          final res = await ModalWrapper.bottomSheet(
                            context: context,
                            widget: StoreOptionModal(
                              options: attribute.possibleValues
                                      ?.map((e) => ModalOption(
                                          title: e,
                                          onTap: () {
                                            ctrs[index].text = e;
                                            Navigator.pop(context);
                                          }))
                                      .toList() ??
                                  [],
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (__, _) => YBox(16),
                    itemCount: vm.selectedAttributeList.length),
                YBox(20),
                //!!OBSCURE VARIENT FLOW!!
                // if (vm.hasVariant == true)
                //   CustomBtn.withChild(
                //     width: Sizer.screenWidth * 0.7,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Icon(
                //           Icons.add,
                //           color: colorScheme.white,
                //         ),
                //         XBox(10),
                //         Text(
                //           "Add Varying Attributes",
                //           style: textTheme.text16?.medium.copyWith(
                //             color: colorScheme.white,
                //           ),
                //         ),
                //       ],
                //     ),
                //     onTap: () {
                //       widget.onNext?.call();
                //     },
                //   )
                // else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Inventory FORM
                    InkWell(
                      onTap: () {
                        setState(() {
                          isViewInventoryInformation =
                              !isViewInventoryInformation;
                        });
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Inventory Information",
                              style: textTheme.text16?.medium,
                            ),
                          ),
                          Icon(isViewInventoryInformation
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down)
                        ],
                      ),
                    ),
                    HDivider(),
                    if (isViewInventoryInformation)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: textTheme.text14,
                              children: [
                                TextSpan(
                                  text: "All asterisk (",
                                ),
                                TextSpan(
                                  text: "*",
                                  style: textTheme.text14?.medium.copyWith(
                                    color: Colors.red,
                                  ),
                                ),
                                TextSpan(
                                  text: ") are required fields",
                                ),
                              ],
                            ),
                          ),
                          YBox(16),
                          CustomTextField(
                            controller: vm.sellingUnitC,
                            labelText: 'Selling Units',
                            hintText: 'Select unit type',
                            showLabelHeader: true,
                            // showSuffixIcon: true,
                            // readOnly: true,
                            onTap: () async {
                              // final res = await ModalWrapper.bottomSheet(
                              //   context: context,
                              //   widget: StoreOptionModal(
                              //     options: attribute.possibleValues
                              //             ?.map((e) => ModalOption(
                              //                 title: e,
                              //                 onTap: () {
                              //                   ctrs[index].text = e;
                              //                   Navigator.pop(context);
                              //                 }))
                              //             .toList() ??
                              //         [],
                              //   ),
                              // );
                            },
                          ),
                          YBox(16),
                          CustomTextField(
                            controller: vm.stockQtyC,
                            labelText: 'Stock Quantity',
                            hintText: 'Enter stock quantity',
                            showLabelHeader: true,
                            // showSuffixIcon: true,
                            // readOnly: true,
                            onTap: () async {
                              // final res = await ModalWrapper.bottomSheet(
                              //   context: context,
                              //   widget: StoreOptionModal(
                              //     options: attribute.possibleValues
                              //             ?.map((e) => ModalOption(
                              //                 title: e,
                              //                 onTap: () {
                              //                   ctrs[index].text = e;
                              //                   Navigator.pop(context);
                              //                 }))
                              //             .toList() ??
                              //         [],
                              //   ),
                              // );
                            },
                          ),
                          YBox(16),
                          CustomTextField(
                            controller: vm.qtyPerSellUnitC,
                            labelText: 'Quantity per Selling Unit',
                            hintText: 'e.g 12 tiles per unit',
                            showLabelHeader: true,
                          ),
                          YBox(16),
                          CustomTextField(
                            controller: vm.minOrderQty,
                            labelText: 'Minimum order quantity',
                            hintText: 'Enter minimum quantity',
                            showLabelHeader: true,
                            // showSuffixIcon: true,
                            // readOnly: true,
                          ),
                          YBox(16),
                          CustomTextField(
                            controller: vm.measurementC,
                            labelText: 'Measurement',
                            hintText: 'Select unit measurement',
                            isRequired: false,
                            showLabelHeader: true,
                            showSuffixIcon: true,
                            readOnly: true,
                            onTap: () async {
                              // final res = await ModalWrapper.bottomSheet(
                              //   context: context,
                              //   widget: StoreOptionModal(
                              //     options: attribute.possibleValues
                              //             ?.map((e) => ModalOption(
                              //                 title: e,
                              //                 onTap: () {
                              //                   ctrs[index].text = e;
                              //                   Navigator.pop(context);
                              //                 }))
                              //             .toList() ??
                              //         [],
                              //   ),
                              // );
                            },
                          ),
                          YBox(16),
                          CustomTextField(
                            controller: vm.dimensionC,
                            labelText: 'Dimension',
                            hintText: 'Enter value',
                            showLabelHeader: true,
                            isRequired: false,
                            // showSuffixIcon: true,
                            // readOnly: true,
                          ),
                          YBox(16),
                          CustomTextField(
                            controller: vm.weightPerSellUnitC,
                            labelText: 'Weight per Selling Unit',
                            hintText: 'Enter value',
                            showLabelHeader: true,

                            // showSuffixIcon: true,
                            // readOnly: true,
                          ),
                          YBox(16),
                          CustomTextField(
                            controller: vm.weightPerUnitItemC,
                            labelText: 'Weight per unit item',
                            hintText: 'Enter value',
                            showLabelHeader: true,
                            isRequired: false,

                            // showSuffixIcon: true,
                            // readOnly: true,
                          ),
                          YBox(16),
                          CustomTextField(
                            controller: vm.reorderLevelC,
                            labelText: 'Re-order Level',
                            hintText: 'Enter value',
                            showLabelHeader: true,
                            isRequired: false,

                            // showSuffixIcon: true,
                            // readOnly: true,
                          ),
                          YBox(16),
                          CustomTextField(
                            controller: vm.skuC,
                            labelText: 'Store Keeping Unit (SKU)',
                            hintText: 'Enter value',
                            showLabelHeader: true,
                            isRequired: false,

                            // showSuffixIcon: true,
                            // readOnly: true,
                          ),
                          YBox(16),
                          UploadWidget(
                            documentName: _docFile?.path.split('/').last,
                            labelText: "Cover Image",
                            uploadText: "Click to upload cover Image.         ",

                            // buttomTextDesc: "",
                            onUpload: () async {
                              // Reset progress tracking for any previous uploads
                              ref.read(fileUploadVm).resetProgress();

                              final file =
                                  await ImageAndDocUtils.pickDocument();
                              if (file != null) {
                                _docFile = file;
                                final r = await ref
                                    .read(fileUploadVm)
                                    .uploadFile(file: [file]);
                                _docUrl = r.data?.first.url;
                              }
                            },
                          ),
                          YBox(16),
                          Row(
                            children: [
                              Expanded(
                                child: UploadWidget(
                                  documentName: _docFile?.path.split('/').last,
                                  labelText: "Other Images",
                                  uploadText: "Click to upload",

                                  // buttomTextDesc: "",
                                  onUpload: () async {
                                    // Reset progress tracking for any previous uploads
                                    ref.read(fileUploadVm).resetProgress();

                                    final file =
                                        await ImageAndDocUtils.pickDocument();
                                    if (file != null) {
                                      _docFile = file;
                                      final r = await ref
                                          .read(fileUploadVm)
                                          .uploadFile(file: [file]);
                                      _docUrl = r.data?.first.url;
                                    }
                                  },
                                ),
                              ),
                              XBox(24),
                              Expanded(
                                child: UploadWidget(
                                  documentName: _docFile?.path.split('/').last,
                                  labelText: "",
                                  uploadText: "Click to upload",

                                  // buttomTextDesc: "",
                                  onUpload: () async {
                                    // Reset progress tracking for any previous uploads
                                    ref.read(fileUploadVm).resetProgress();

                                    final file =
                                        await ImageAndDocUtils.pickDocument();
                                    if (file != null) {
                                      _docFile = file;
                                      final r = await ref
                                          .read(fileUploadVm)
                                          .uploadFile(file: [file]);
                                      _docUrl = r.data?.first.url;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    YBox(16),
                    //Pricing FORM
                    InkWell(
                      onTap: () {
                        setState(() {
                          isViewPricingInformation = !isViewPricingInformation;
                        });
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Pricing Information",
                              style: textTheme.text16?.medium,
                            ),
                          ),
                          Icon(isViewPricingInformation
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down)
                        ],
                      ),
                    ),
                    HDivider(),
                    if (isViewPricingInformation)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: textTheme.text14,
                              children: [
                                TextSpan(
                                  text: "All asterisk (",
                                ),
                                TextSpan(
                                  text: "*",
                                  style: textTheme.text14?.medium.copyWith(
                                    color: Colors.red,
                                  ),
                                ),
                                TextSpan(
                                  text: ") are required fields",
                                ),
                              ],
                            ),
                          ),
                          YBox(16),
                          CustomTextField(
                            controller: vm.costPricePerUnitC,
                            labelText: 'Cost Price per Unit',
                            hintText: '0.00',
                            showLabelHeader: true,
                            // showSuffixIcon: true,
                            // readOnly: true,
                          ),
                          YBox(16),
                          CustomTextField(
                            controller: vm.sellingPricePerUnitC,
                            labelText: 'Selling Price per Unit',
                            hintText: '0.00',
                            showLabelHeader: true,
                            // showSuffixIcon: true,
                            // readOnly: true,
                          ),
                          YBox(16),
                          CustomTextField(
                            controller: vm.discountPriceC,
                            labelText: 'Discount Price',
                            optionalText: "(Optional)",
                            hintText: '0.00',
                            showLabelHeader: true,
                            isRequired: false,
                            // showSuffixIcon: true,
                            // readOnly: true,
                          ),
                        ],
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
                              widget.onNext?.call();
                            },
                            text: "Next",
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        YBox(16),
      ],
    );
  }
}
