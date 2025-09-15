import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/services.dart';

class NewDiscountScreen extends ConsumerStatefulWidget {
  const NewDiscountScreen({super.key});

  @override
  ConsumerState<NewDiscountScreen> createState() => _NewDiscountScreenState();
}

class _NewDiscountScreenState extends ConsumerState<NewDiscountScreen> {
  final _formKey = GlobalKey<FormState>();
  final discountCategory = TextEditingController();
  String? selectedCategory;
  final discountName = TextEditingController();
  final discountCode = TextEditingController();
  final discountType = TextEditingController();
  String? selectedType;
  final discountValue = TextEditingController();
  final searchCtr = TextEditingController();
  bool? isAllProducts;
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  List<ProductModel> selectedProducts = [];
  // String? selectedLabel;
  dynamic roleId;

  @override
  void dispose() {
    discountCategory.dispose();
    discountName.dispose();
    discountCode.dispose();
    discountType.dispose();
    searchCtr.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    discountValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final vm = ref.watch(discountVm);
    return BusyOverlay(
      show: vm.isBusy,
      child: Scaffold(
          appBar: CustomAppbar(
            title: "New Discount",
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
                  Text("Add New Discount", style: textTheme.text16?.medium),
                  Text(
                    "Fill the form below to add a new discount",
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: discountCategory,
                    isRequired: false,
                    labelText: 'Discount Application',
                    // optionalText: "(optional)",
                    hintText: 'Select discount application',
                    showLabelHeader: true,
                    readOnly: true,
                    showSuffixIcon: true,
                    validator: Validators.required(),
                    onTap: () async {
                      final res = await ModalWrapper.bottomSheet(
                        context: context,
                        widget:
                            DiscountOptionsModal.application(context: context),
                      );
                      if (res is String) {
                        selectedCategory = res;
                        discountCategory.text = res == "products"
                            ? "Discount per product"
                            : "Discount on total orders";
                        setState(() {});
                      }
                    },
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: discountName,
                    isRequired: false,
                    labelText: 'Name',
                    hintText: 'Enter discount name',
                    showLabelHeader: true,
                    validator: Validators.required(),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: discountCode,
                    isRequired: false,
                    labelText: 'Code',
                    hintText: 'Enter discount code',
                    showLabelHeader: true,
                    validator: Validators.required(),
                  ),
                  YBox(16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _startDateController,
                          labelText: 'Start Date',
                          hintText: 'dd/mm/yyyy',
                          showLabelHeader: true,
                          isRequired: false,
                          validator: Validators.required(),
                          readOnly: true,
                          onTap: () async {
                            final res =
                                await showDialog<Map<String, DateTime?>>(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  insetPadding: EdgeInsets.symmetric(
                                      horizontal: Sizer.width(16)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(Sizer.radius(16)),
                                  ),
                                  child: CustomDatePicker(
                                    initialDate: startDate ?? DateTime.now(),
                                    minDate: DateTime.now(),
                                    maxDate: DateTime.now().add(const Duration(
                                        days: 365)), // 1 year from now
                                    onDateSelected: (startDate, rangeEndDate) {
                                      Navigator.of(context)
                                          .pop({'startDate': startDate});
                                    },
                                  ),
                                );
                              },
                            );

                            if (res != null) {
                              setState(() {
                                startDate = res['startDate'];
                                if (startDate != null) {
                                  _startDateController.text =
                                      "${startDate!.day}/${startDate!.month}/${startDate!.year}";
                                }
                              });
                            }
                          },
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(
                              right: Sizer.radius(10),
                              left: Sizer.radius(4),
                            ),
                            child: SvgPicture.asset(AppSvgs.inputSuffix),
                          ),
                        ),
                      ),
                      XBox(16),
                      Expanded(
                        child: CustomTextField(
                          controller: _endDateController,
                          labelText: 'End Date',
                          hintText: 'dd/mm/yyyy',
                          validator: Validators.required(),
                          showLabelHeader: true,
                          isRequired: false,
                          readOnly: true,
                          onTap: () async {
                            final res =
                                await showDialog<Map<String, DateTime?>>(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  insetPadding: EdgeInsets.symmetric(
                                      horizontal: Sizer.width(16)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(Sizer.radius(16)),
                                  ),
                                  child: CustomDatePicker(
                                    initialDate: endDate ?? DateTime.now(),
                                    minDate: startDate ?? DateTime.now(),
                                    maxDate: DateTime.now().add(const Duration(
                                        days: 365)), // 1 year from now
                                    onDateSelected: (endDate, rangeEndDate) {
                                      Navigator.of(context)
                                          .pop({'endDate': endDate});
                                    },
                                  ),
                                );
                              },
                            );

                            if (res != null) {
                              setState(() {
                                endDate = res['endDate'];
                                if (endDate != null) {
                                  _endDateController.text =
                                      "${endDate!.day}/${endDate!.month}/${endDate!.year}";
                                }
                              });
                            }
                          },
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(
                              right: Sizer.radius(10),
                              left: Sizer.radius(4),
                            ),
                            child: SvgPicture.asset(AppSvgs.inputSuffix),
                          ),
                        ),
                      ),
                    ],
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: discountType,
                    isRequired: false,
                    labelText: 'Discount Type',
                    // optionalText: "(optional)",
                    hintText: 'Select discount type',
                    showLabelHeader: true,
                    readOnly: true,
                    showSuffixIcon: true,
                    validator: Validators.required(),
                    onTap: () async {
                      final res = await ModalWrapper.bottomSheet(
                        context: context,
                        widget: DiscountOptionsModal.type(context: context),
                      );
                      if (res is String) {
                        selectedType = res;
                        discountType.text =
                            res == "amount" ? "Amount off" : "Percentage off";
                        setState(() {});
                      }
                    },
                  ),
                  if (selectedType != null)
                    Column(
                      children: [
                        YBox(16),
                        CustomTextField(
                          controller: discountValue,
                          isRequired: false,
                          labelText: selectedType == 'amount'
                              ? 'Amount'
                              : 'Percentage Off',
                          hintText: 'Enter value',
                          showLabelHeader: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: Validators.required(),
                        ),
                      ],
                    ),
                  YBox(16),
                  Text("Is the discount for all products:"),
                  Row(
                    children: [
                      Radio(
                        activeColor: AppColors.blueDD9,
                        value: true,
                        groupValue: isAllProducts,
                        onChanged: (value) {
                          // Handle change
                          isAllProducts = value;
                          setState(() {});
                        },
                      ),
                      Text("Yes"),
                      Radio(
                        activeColor: AppColors.blueDD9,
                        value: false,
                        groupValue: isAllProducts,
                        onChanged: (value) {
                          // Handle change
                          isAllProducts = value;
                          setState(() {});
                        },
                      ),
                      Text("No"),
                    ],
                  ),
                  YBox(16),
                  if (isAllProducts == false)
                    CustomTextField(
                      controller: searchCtr,
                      labelText: 'Select/Search Products',
                      isRequired: false,
                      readOnly: true,
                      hintText: 'Search products',
                      showLabelHeader: true,
                      showSuffixIcon: true,
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(
                          right: Sizer.radius(10),
                          left: Sizer.radius(4),
                        ),
                        child: Icon(Icons.search, color: AppColors.gray500),
                      ),
                      onTap: () async {
                        final res = await ModalWrapper.bottomSheet(
                            context: context,
                            widget: SearchProductModal(
                              initialSelectedProducts: selectedProducts,
                            ));
                        if (res != null && res is Map<String, dynamic>) {
                          selectedProducts = res['products'] ?? [];

                          setState(() {});
                        }
                      },
                      // validator: Validators.required(),
                    ),
                  if (selectedProducts.isNotEmpty)
                    ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 16),
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final product = selectedProducts[index];
                          return ProductTile(
                            product: product,
                            onTap: () {
                              selectedProducts.remove(product);
                              setState(() {});
                            },
                          );
                        },
                        separatorBuilder: (ctx, _) => YBox(12),
                        itemCount: selectedProducts.length),
                  YBox(32),
                  CustomBtn.solid(
                    text: "Save",
                    onTap: () async {
                      if (_formKey.currentState?.validate() == true) {
                        ModalWrapper.bottomSheet(
                            context: context,
                            widget: ConfirmationModal(
                                modalConfirmationArg: ModalConfirmationArg(
                              iconPath: AppSvgs.infoCircle,
                              title: "Create Discount",
                              description:
                                  "Are you sure you want to create this discount? The discounts is automatically attached to the product",
                              solidBtnText: "Yes, create",
                              outlineBtnText: "No, cancel",
                              isLoading: vm.isBusy,
                              onOutlineBtnOnTap: () async {
                                Navigator.pop(context);
                              },
                              onSolidBtnOnTap: () async {
                                Navigator.pop(context);
                                final res = await vm.addDiscount(
                                    name: discountName.text,
                                    category: selectedCategory ?? "",
                                    code: discountCode.text,
                                    startDate: startDate != null
                                        ? startDate!
                                            .toIso8601String()
                                            .split("T")
                                            .first
                                        : "",
                                    endDate: endDate != null
                                        ? endDate!
                                            .toIso8601String()
                                            .split("T")
                                            .first
                                        : "",
                                    type: selectedType ?? "",
                                    isAllProducts: isAllProducts ?? false,
                                    value: discountValue.text,
                                    products: _reduceProductList());

                                handleApiResponse(
                                    response: res,
                                    onSuccess: () {
                                      Navigator.pop(context);
                                    });
                              },
                            )));
                        // final res = await vm.addNewStaff(
                        //     fullName: fullNameC.text,
                        //     email: emailC.text,
                        //     phone: phoneC.text,
                        //     roleId: roleId);

                        // handleApiResponse(
                        //   response: res,
                        //   onSuccess: () {
                        //     ModalWrapper.bottomSheet(
                        //       context: context,
                        //       canDismiss: false,
                        //       widget: ConfirmationModal(
                        //         modalConfirmationArg: ModalConfirmationArg(
                        //           iconPath: AppSvgs.checkIcon,
                        //           title: "Staff Invite Sent Successfully",
                        //           description:
                        //               "An invite has been sent to this user to join Builder’sKonnect. The user will be required to create their own password to Login.",
                        //           solidBtnText: "Okay, Good",
                        //           onSolidBtnOnTap: () {
                        //             Navigator.pop(context);
                        //             Navigator.pop(context);
                        //           },
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // );
                      }
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }

  List<String> _reduceProductList(){
    return selectedProducts.map((item) => item.id ?? '').toList();
  }
}

//Widgets
class ProductTile extends StatelessWidget {
  final ProductModel? product;
  final void Function()? onTap;
  const ProductTile({super.key, this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Sizer.radius(12)),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(Sizer.radius(4)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: Sizer.width(24),
                height: Sizer.width(24),
                decoration: BoxDecoration(
                  color: AppColors.black23,
                  borderRadius: BorderRadius.circular(Sizer.radius(4)),
                  image: product?.media != null &&
                          (product?.media?.isNotEmpty ?? false) &&
                          product?.media?.first != null
                      ? DecorationImage(
                          image: NetworkImage(product?.media?.first ?? ""),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
              XBox(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product?.name ?? "",
                        style: Theme.of(context).textTheme.text14),
                    YBox(4),
                    Text(product?.category ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .text12
                            ?.copyWith(color: AppColors.gray500)),
                  ],
                ),
              ),
              XBox(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("SKU",
                        style: Theme.of(context)
                            .textTheme
                            .text14
                            ?.copyWith(color: AppColors.gray500)),
                    YBox(4),
                    Text(product?.sku ?? "",
                        style: Theme.of(context).textTheme.text12),
                  ],
                ),
              ),
            ],
          ),
          YBox(4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Amount: ",
                        style:
                            Theme.of(context).textTheme.text12?.medium.copyWith(
                                  color: AppColors.gray500,
                                  fontFamily: "Roboto",
                                ),
                      ),
                      TextSpan(
                        text: "N ${AppUtils.formatNumber(
                          number: num.parse(
                              product?.retailPrice?.toString() ?? '0'),
                        )}",
                        style: Theme.of(context)
                            .textTheme
                            .text12
                            ?.medium
                            .copyWith(
                              color: Theme.of(context).colorScheme.primaryColor,
                              fontFamily: "Roboto",
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              XBox(12),
              Flexible(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Stock Level: ",
                        style:
                            Theme.of(context).textTheme.text12?.medium.copyWith(
                                  color: AppColors.gray500,
                                  fontFamily: "Roboto",
                                ),
                      ),
                      TextSpan(
                        text: AppUtils.formatNumber(
                          number:
                              num.parse(product?.quantity?.toString() ?? '0'),
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .text12
                            ?.medium
                            .copyWith(
                              color: Theme.of(context).colorScheme.primaryColor,
                              fontFamily: "Roboto",
                            ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          YBox(8),
          InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: Sizer.radius(8),
                horizontal: Sizer.radius(12),
              ),
              color: AppColors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppSvgs.trashOutline),
                  XBox(8),
                  Text(
                    "Remove",
                    style: Theme.of(context).textTheme.text14?.medium.copyWith(
                          color: AppColors.red,
                        ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
