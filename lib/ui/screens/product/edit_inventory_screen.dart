// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/services.dart';

class EditInventoryScreen extends ConsumerStatefulWidget {
  const EditInventoryScreen({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  ConsumerState<EditInventoryScreen> createState() =>
      _EditInventoryScreenState();
}

class _EditInventoryScreenState extends ConsumerState<EditInventoryScreen> {
  final formKey = GlobalKey<FormState>();
  final _currentStockLevelC = TextEditingController();
  final _additionalStockQuantityC = TextEditingController();
  final _minimumOrderQuantityC = TextEditingController();
  final _reOrderValueC = TextEditingController();
  final _costPriceC = TextEditingController();
  final _sellingPriceC = TextEditingController();
  final _discountPriceC = TextEditingController();

  ProductModel? productDetails;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productDetails = widget.product;

      _currentStockLevelC.text = widget.product.quantity?.toString() ?? "";
      _reOrderValueC.text = widget.product.reorderValue?.toString() ?? "";
      _costPriceC.text = widget.product.costPrice?.toString() ?? "";
      _sellingPriceC.text = widget.product.retailPrice?.toString() ?? "";
      _discountPriceC.text = widget.product.currentPrice?.toString() ?? "";

      setState(() {});
    });
  }

  @override
  void dispose() {
    _currentStockLevelC.dispose();
    _additionalStockQuantityC.dispose();
    _minimumOrderQuantityC.dispose();
    _reOrderValueC.dispose();
    _costPriceC.dispose();
    _sellingPriceC.dispose();
    _discountPriceC.dispose();
    super.dispose();
  }

  _getProductDetails() async {
    final prodVm = ref.read(productInventoryVmodel);
    final res = await prodVm.viewProductInventory(
      productId: widget.product.id ?? "",
    );
    if (res.success) {
      productDetails = res.data;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final inventoryVm = ref.watch(productInventoryVmodel);
    return BusyOverlay(
      show: inventoryVm.busy(updateState) || inventoryVm.busy(viewState),
      child: Scaffold(
        appBar: CustomAppbar(
          title: "Edit Inventory and Pricing",
        ),
        body: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: RefreshIndicator(
            onRefresh: () async {
              await _getProductDetails();
            },
            child: ListView(
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
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        YBox(16),
                        Container(
                          padding: EdgeInsets.all(Sizer.radius(16)),
                          decoration: BoxDecoration(
                            color: AppColors.neutral3,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Product Name",
                                          style: textTheme.text12?.copyWith(
                                            color: AppColors.grey175,
                                          ),
                                        ),
                                        YBox(4),
                                        Text(
                                          productDetails?.name ?? "N/A",
                                          style:
                                              textTheme.text14?.medium.copyWith(
                                            color: AppColors.black23,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  OrderStatus(
                                      status: productDetails?.status ?? "N/A")
                                ],
                              ),
                              YBox(16),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Stock Level",
                                        style: textTheme.text12?.copyWith(
                                          color: AppColors.grey175,
                                        ),
                                      ),
                                      YBox(4),
                                      Text(
                                        productDetails?.quantity?.toString() ??
                                            "N/A",
                                        style:
                                            textTheme.text14?.medium.copyWith(
                                          color: AppColors.yellow6,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Re-order Level",
                                        style: textTheme.text12?.copyWith(
                                          color: AppColors.grey175,
                                        ),
                                      ),
                                      YBox(4),
                                      Text(
                                        productDetails?.reorderValue
                                                ?.toString() ??
                                            "N/A",
                                        style:
                                            textTheme.text14?.medium.copyWith(
                                          color: AppColors.black23,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              YBox(16),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Selling Price",
                                        style: textTheme.text12?.copyWith(
                                          color: AppColors.grey175,
                                        ),
                                      ),
                                      YBox(4),
                                      Text(
                                        "${AppUtils.nairaSymbol}${AppUtils.formatNumber(
                                          decimalPlaces: 2,
                                          number: double.tryParse(
                                                  productDetails?.costPrice ??
                                                      "0.0") ??
                                              0.0,
                                        )}",
                                        style:
                                            textTheme.text14?.medium.copyWith(
                                          color: colorScheme.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "SKU",
                                        style: textTheme.text12?.copyWith(
                                          color: AppColors.grey175,
                                        ),
                                      ),
                                      YBox(4),
                                      Text(
                                        productDetails?.sku ?? "N/A",
                                        style:
                                            textTheme.text14?.medium.copyWith(
                                          color: AppColors.black23,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        YBox(24),
                        CustomTextField(
                          controller: _currentStockLevelC,
                          labelText: 'Current Stock Level',
                          hintText: "Select unit type",
                          showLabelHeader: true,
                          fillColor: AppColors.neutral3,
                          readOnly: true,
                          showSuffixIcon: true,
                          validator: Validators.required(),
                          suffixIcon: SuffixBox(
                              text: productDetails?.measurementUnit ?? ""),
                          onTap: () {},
                        ),
                        YBox(16),
                        CustomTextField(
                          controller: _additionalStockQuantityC,
                          labelText: 'Additional Stock ',
                          hintText: 'Enter stock quantity',
                          showLabelHeader: true,
                          validator: Validators.required(),
                          keyboardType: TextInputType.number,
                          suffixIcon: SuffixBox(
                              text: productDetails?.measurementUnit ?? ""),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onTap: () {},
                        ),
                        YBox(16),
                        CustomTextField(
                          controller: _minimumOrderQuantityC,
                          labelText: 'Minimum Order Quantity',
                          hintText: 'Enter minimum order quantity',
                          showLabelHeader: true,
                          keyboardType: TextInputType.number,
                          suffixIcon: SuffixBox(
                              text: productDetails?.measurementUnit ?? ""),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: Validators.required(),
                        ),
                        YBox(16),
                        CustomTextField(
                          controller: _reOrderValueC,
                          labelText: 'Reorder Level',
                          hintText: 'Enter reorder level',
                          showLabelHeader: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: Validators.required(),
                        ),
                        YBox(16),
                        CustomTextField(
                          controller: _costPriceC,
                          labelText: 'Cost Price *',
                          hintText: '00.00',
                          showLabelHeader: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(Sizer.radius(10)),
                            child: SvgPicture.asset(
                              AppSvgs.naira,
                              fit: BoxFit.cover,
                            ),
                          ),
                          validator: Validators.required(),
                        ),
                        YBox(16),
                        CustomTextField(
                          controller: _sellingPriceC,
                          labelText: 'Selling Price *',
                          hintText: '00.00',
                          showLabelHeader: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(Sizer.radius(10)),
                            child: SvgPicture.asset(
                              AppSvgs.naira,
                              fit: BoxFit.cover,
                            ),
                          ),
                          validator: Validators.required(),
                        ),
                        YBox(16),
                        CustomTextField(
                          controller: _discountPriceC,
                          labelText: 'Discount Price',
                          optionalText: "(optional)",
                          hintText: '00.00',
                          showLabelHeader: true,
                          isRequired: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(Sizer.radius(10)),
                            child: SvgPicture.asset(
                              AppSvgs.naira,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        YBox(32),
                        CustomBtn.solid(
                          text: "Save Changes",
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            final result = await ModalWrapper.bottomSheet(
                              context: context,
                              widget: ConfirmationModal(
                                modalConfirmationArg: ModalConfirmationArg(
                                  iconPath: AppSvgs.infoCircle,
                                  title: "Save Inventory Changes",
                                  description:
                                      "Are you sure you want to update this product inventory? Once updated the product inventory will increase according to the stock quantity added.",
                                  solidBtnText: "Yes, save",
                                  onSolidBtnOnTap: () {
                                    Navigator.pop(context, true);
                                  },
                                  onOutlineBtnOnTap: () {
                                    Navigator.pop(context, false);
                                  },
                                ),
                              ),
                            );
                            if (result == true) {
                              final res = await ref
                                  .read(productInventoryVmodel)
                                  .editInventoryLevel(
                                    productId: productDetails?.id ?? "",
                                    quantity:
                                        _additionalStockQuantityC.text.trim(),
                                    minimumOrderQuantity:
                                        _minimumOrderQuantityC.text.trim(),
                                    reOrderValue: _reOrderValueC.text.trim(),
                                    costPrice: _costPriceC.text.trim(),
                                    retailPrice: _sellingPriceC.text.trim(),
                                    currentPrice: _discountPriceC.text.trim(),
                                  );

                              handleApiResponse(
                                response: res,
                                onSuccess: () async {
                                  await _getProductDetails();
                                  ref
                                      .read(productInventoryVmodel)
                                      .getInventoryProducts();
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
