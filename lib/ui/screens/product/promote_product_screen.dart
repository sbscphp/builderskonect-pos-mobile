import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class PromoteProductScreen extends ConsumerStatefulWidget {
  const PromoteProductScreen({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  ConsumerState<PromoteProductScreen> createState() =>
      _PromoteProductScreenState();
}

class _PromoteProductScreenState extends ConsumerState<PromoteProductScreen> {
  bool showFeatureInfo = true;
  final _discount = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  bool isAgreed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productInventoryVmodel).fetchPromotionFees();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final productVm = ref.watch(productInventoryVmodel);
    // printty(widget.product.toJson().toString());
    return Scaffold(
      appBar: CustomAppbar(
        title: "Promote Product",
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: Sizer.width(16),
          right: Sizer.width(16),
          bottom: Sizer.height(50),
        ),
        children: [
          YBox(16.h),
          if (showFeatureInfo)
            FeatureInfoContainer(
              onClose: () {
                setState(() {
                  showFeatureInfo = false;
                });
              },
            ),
          YBox(16.h),
          //Selected Product Card
          Container(
            padding: EdgeInsets.all(Sizer.radius(12)),
            decoration: BoxDecoration(
              color: colorScheme.white,
              borderRadius: BorderRadius.circular(Sizer.radius(4.r)),
              border: Border.all(color: AppColors.greenED),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Selected Product",
                      style: textTheme.text14?.medium,
                    ),
                  ],
                ),
                Divider(
                  color: AppColors.grey.withValues(alpha: .3),
                ),
                YBox(12.h),
                ProductWithSkuListTile(
                  productImage: widget.product.primaryMediaUrl ?? "",
                  productTitle: widget.product.name ?? '',
                  subTitle: widget.product.productType ?? '',
                  sku: widget.product.sku ?? '',
                ),
                YBox(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Price: ",
                              style: textTheme.text12?.medium.copyWith(
                                color: AppColors.gray500,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "${AppUtils.nairaSymbol}${AppUtils.formatNumber(decimalPlaces: 2, number: double.tryParse(widget.product.costPrice ?? "0") ?? 0)}",
                              style: textTheme.text12?.medium.copyWith(
                                color: colorScheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    XBox(30),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Stock level: ",
                            style: textTheme.text12?.medium.copyWith(
                              color: AppColors.gray500,
                            ),
                          ),
                          TextSpan(
                            text: widget.product.quantity?.toString() ?? '',
                            style: textTheme.text12?.medium.copyWith(
                              color: AppColors.neutral11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        YBox(12.h),
                        Text("Discount:"),
                      ],
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Expanded(
                        child: CustomTextField(
                      controller: _discount,
                      onChanged: (value) => setState(() {}),
                      height: 32,
                      isRequired: false,
                      hintText: "${AppUtils.nairaSymbol}00.00",
                    ))
                  ],
                ),
                YBox(16.h),
                CustomBtn.solid(
                    onTap: _discount.text.isEmpty
                        ? null
                        : () async {
                            final response =
                                await productVm.updateDiscountPrice(
                                    discountPrice: _discount.text,
                                    productId: widget.product.id ?? "");

                            handleApiResponse(
                              response: response,
                              successMsg: "Discount Price updated successfully",
                              onSuccess: () {
                                _discount.clear();
                              },
                            );
                          },
                    isLoading: productVm.busy(updateState),
                    text: "Save Price")
              ],
            ),
          ),
          YBox(16.h),
          //Listing Type Card
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.white,
              borderRadius: BorderRadius.circular(Sizer.radius(4.r)),
              border: Border.all(color: AppColors.greenED),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Listing Type",
                      style: textTheme.text14?.medium,
                    ),
                  ],
                ),
                Divider(
                  color: AppColors.grey.withValues(alpha: .3),
                ),
                YBox(12.h),
                Builder(builder: (context) {
                  if (productVm.busy(getFeesState)) {
                    return const Center(
                      child: SizerLoader(height: 150),
                    );
                  }
                  return ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final promoData =
                            productVm.promotionFeesResponse?.data?[index];
                        return InkWell(
                          onTap: () {
                            productVm.selectedFeeData = promoData;
                            //reset dependent predicate and variables:
                            selectedStartDate = null;
                            selectedEndDate = null;
                            _startDateController.clear();
                            _endDateController.clear();
                            productVm.paymentBreakdownResponse = null;
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 8.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                    color:
                                        productVm.selectedFeeData == promoData
                                            ? AppColors.blueDD9
                                            : AppColors.mischkaGrey)),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          RichText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "${promoData?.name ?? ''} - ",
                                                  style: textTheme
                                                      .text12?.medium
                                                      .copyWith(
                                                    color: AppColors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "${AppUtils.nairaSymbol}${AppUtils.formatNumber(number: promoData?.chargeValue ?? 0)}",
                                                  style: textTheme
                                                      .text12?.medium
                                                      .copyWith(
                                                    color: colorScheme
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      YBox(8.h),
                                      RichText(
                                          text: TextSpan(
                                              text:
                                                  "${promoData?.name ?? ''} allows your product to be part of the top listed products.",
                                              style: textTheme.text12?.copyWith(
                                                color: AppColors.grey175,
                                              ),
                                              children: [
                                            TextSpan(
                                              text: " Limited seats available",
                                              style: textTheme.text12?.copyWith(
                                                color: AppColors.red22,
                                              ),
                                            )
                                          ]))
                                    ],
                                  ),
                                ),
                                XBox(16.w),
                                CustomRadioBtn(
                                  isSelected:
                                      productVm.selectedFeeData == promoData,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (__, _) => YBox(12.h),
                      itemCount:
                          productVm.promotionFeesResponse?.data?.length ?? 0);
                }),
              ],
            ),
          ),
          YBox(16.h),
          //Promo Duraation
          if (productVm.selectedFeeData != null)
            Container(
              padding: EdgeInsets.all(Sizer.radius(12)),
              decoration: BoxDecoration(
                color: colorScheme.white,
                borderRadius: BorderRadius.circular(Sizer.radius(4.r)),
                border: Border.all(color: AppColors.greenED),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Promo Duration",
                        style: textTheme.text14?.medium,
                      ),
                    ],
                  ),
                  Divider(
                    color: AppColors.grey.withValues(alpha: .3),
                  ),
                  YBox(12.h),
                  CustomTextField(
                    controller: _startDateController,
                    labelText: 'Start Date',
                    hintText: 'Select Date',
                    showLabelHeader: true,
                    isRequired: true,
                    readOnly: true,
                    onTap: () async {
                      final result = await showDialog<Map<String, DateTime?>>(
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
                              initialDate: selectedStartDate ?? DateTime.now(),
                              // endDate: endDate,
                              minDate: DateTime.now(), // today
                              maxDate: DateTime.now().add(
                                  const Duration(days: 365)), // 1 year from now
                              onDateSelected: (startDate, rangeEndDate) {
                                Navigator.of(context).pop({
                                  'startDate': startDate,
                                  'endDate': rangeEndDate,
                                });
                              },
                            ),
                          );
                        },
                      );
                      if (result != null) {
                        setState(() {
                          selectedStartDate = result['startDate'];
                          // Update text controllers
                          printty(selectedStartDate);
                          if (selectedStartDate != null) {
                            _startDateController.text =
                                "${selectedStartDate!.day}/${selectedStartDate!.month}/${selectedStartDate!.year}";
                            //handles previous selection
                            _endDateController.clear();
                            selectedEndDate = null;
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
                  YBox(12.h),
                  CustomTextField(
                    controller: _endDateController,
                    labelText: 'End Date',
                    hintText: 'Select Date',
                    showLabelHeader: true,
                    isRequired: true,
                    readOnly: true,
                    onTap: selectedStartDate == null
                        ? null
                        : () async {
                            final result =
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
                                    initialDate: selectedEndDate ??
                                        selectedStartDate
                                            ?.add(Duration(days: 1)) ??
                                        DateTime.now(),
                                    // endDate: endDate,
                                    minDate: selectedStartDate
                                        ?.add(Duration(days: 1)), // 1 day ahead
                                    maxDate: selectedStartDate?.add(
                                        const Duration(
                                            days: 365)), // 1 year from now
                                    onDateSelected: (startDate, rangeEndDate) {
                                      Navigator.of(context).pop({
                                        'startDate': startDate,
                                        'endDate': rangeEndDate,
                                      });
                                    },
                                  ),
                                );
                              },
                            );
                            if (result != null) {
                              setState(() {
                                selectedEndDate = result['startDate'];
                                // Update text controllers
                                if (selectedEndDate != null) {
                                  _endDateController.text =
                                      "${selectedEndDate!.day}/${selectedEndDate!.month}/${selectedEndDate!.year}";
                                }
                              });
                              //todo::: handle call here
                              final response =
                                  await productVm.getPaymentBreakdown(
                                      endDate: selectedEndDate,
                                      startDate: selectedStartDate);
                              handleApiResponse(response: response);
                            }
                          },
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(
                        right: Sizer.radius(10),
                        left: Sizer.radius(4),
                      ),
                      child: SvgPicture.asset(AppSvgs.inputSuffix),
                    ),
                  )
                ],
              ),
            ),
          YBox(16.h),
          if (productVm.paymentBreakdownResponse != null &&
              !productVm.error(paymentBreakdownState))
            Container(
              padding: EdgeInsets.all(Sizer.radius(12)),
              decoration: BoxDecoration(
                color: colorScheme.white,
                borderRadius: BorderRadius.circular(Sizer.radius(4.r)),
                border: Border.all(color: AppColors.greenED),
              ),
              child: Builder(builder: (context) {
                if (productVm.busy(paymentBreakdownState)) {
                  return Center(
                    child: SizerLoader(
                      height: 150.h,
                    ),
                  );
                }
                return Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Agreement and Order Summary",
                          style: textTheme.text14?.medium,
                        ),
                      ],
                    ),
                    Divider(
                      color: AppColors.grey.withValues(alpha: .3),
                    ),
                    YBox(12.h),
                    Row(
                      children: [
                        CustomCheckbox(
                          isSelected: isAgreed,
                          onTap: () {
                            setState(() {
                              isAgreed = !isAgreed;
                            });
                          },
                        ),
                        XBox(6.w),
                        Flexible(
                          child: Text(
                              "By Promoting this product, I understand that the product will listed on the deals of the day section for the selected duration,"),
                        ),
                      ],
                    ),
                    YBox(16.h),
                    Container(
                      padding: EdgeInsets.all(Sizer.radius(12)),
                      decoration: BoxDecoration(
                        color: AppColors.dayBreakBlue,
                        borderRadius: BorderRadius.circular(Sizer.radius(8.r)),
                        border: Border.all(color: AppColors.dayBreakBlue),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Price per day",
                                style: textTheme.text12?.copyWith(
                                  color: AppColors.grey175,
                                ),
                              ),
                              Text(
                                "${productVm.paymentBreakdownResponse?.data?.fee}",
                                style: textTheme.text12?.copyWith(
                                  color: AppColors.black,
                                ),
                              )
                            ],
                          ),
                          YBox(12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Days selected",
                                style: textTheme.text12?.copyWith(
                                  color: AppColors.grey175,
                                ),
                              ),
                              Text(
                                "${productVm.paymentBreakdownResponse?.data?.duration}",
                                style: textTheme.text12?.copyWith(
                                  color: AppColors.black,
                                ),
                              )
                            ],
                          ),
                          Divider(
                            color: AppColors.grey.withValues(alpha: .3),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total ",
                                style: textTheme.text14?.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                              Text(
                                "${productVm.paymentBreakdownResponse?.data?.total}",
                                style: textTheme.text14?.copyWith(
                                  color: AppColors.primaryBlue,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    YBox(16.h),
                    CustomBtn.solid(
                        onTap: () async {
                          if (isAgreed) {
                            final res = await productVm.creatPromotion(
                              productId: widget.product.id ?? "",
                              callbackUrl: AppConfig.callBackUrl,
                              endDate: selectedEndDate,
                              startDate: selectedStartDate,
                            );

                            handleApiResponse(
                              response: res,
                              onSuccess: () {
                                Navigator.pushNamed(
                                  context,
                                  RoutePath.customWebviewScreen,
                                  arguments: WebViewArg(
                                    webURL: res.data["data"]
                                        ["authorization_url"],
                                    onSucecess: () async {
                                      Navigator.pop(context);

                                      // subscribe the user
                                      final result =
                                          await productVm.verifyPayment(
                                        res.data["data"]["reference"],
                                      );

                                      handleApiResponse(
                                        response: result,
                                        onSuccess: () {
                                          ModalWrapper.bottomSheet(
                                            context: NavKey
                                                .appNavKey.currentContext!,
                                            canDismiss: false,
                                            isScrollControlled: false,
                                            widget: ConfirmationModal(
                                              modalConfirmationArg:
                                                  ModalConfirmationArg(
                                                iconPath: AppSvgs.checkIcon,
                                                title:
                                                    "Product Promoted Successfully",
                                                description:
                                                    "Your product has been promoted on the deals of the day feature on the e-commerce app. Get ready to sell faster.",
                                                solidBtnText: "Great",
                                                onSolidBtnOnTap: () {
                                                  // Get navigation context safely
                                                  final navCtx = NavKey
                                                      .appNavKey.currentContext;
                                                  if (navCtx == null) return;

                                                  Navigator.pop(navCtx);
                                                  Navigator.pop(navCtx);
                                                  Navigator.pop(navCtx);
                                                  Navigator.pop(navCtx);
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          } else {
                            FlushBarToast.fLSnackBar(
                                message: "Kindly agree to Order Summary");
                          }
                        },
                        isLoading: productVm.busy(createPromotionState),
                        text: "Proceed to Payment")
                  ],
                );
              }),
            )
        ],
      ),
    );
  }
}

//Widgets
class FeatureInfoContainer extends StatelessWidget {
  final VoidCallback? onClose;
  const FeatureInfoContainer({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(
        Sizer.radius(12),
      ),
      decoration: BoxDecoration(
        color: colorScheme.white,
        border: Border.all(color: AppColors.blueDD9),
        borderRadius: BorderRadius.circular(Sizer.radius(8.r)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                AppSvgs.caution,
                height: Sizer.height(42),
              ),
              InkWell(onTap: onClose, child: Icon(Icons.close))
            ],
          ),
          YBox(8.h),
          Row(
            children: [
              Text(
                "Get Featured. Get Noticed. Get Sales.",
                style: textTheme.text14?.medium,
              ),
            ],
          ),
          YBox(8.h),
          Row(
            children: [
              Flexible(
                child: Text(
                  "Feature your products on Deals of the Day for just and enjoy more visibility, higher conversions, and faster sales",
                  style: textTheme.text12,
                ),
              ),
            ],
          ),
          YBox(8.h),
          FeaturePoint(
            data: "Have an active, verified vendor account",
          ),
          YBox(8.h),
          FeaturePoint(
            data:
                "Have no outstanding disputes, payment issues, or policy violations",
          ),
          YBox(8.h),
          FeaturePoint(
            data:
                "Be currently in stock with sufficient inventory to fulfill expected demandt",
          ),
          YBox(8.h),
          FeaturePoint(
            data: "Be priced competitively within the market range",
          ),
        ],
      ),
    );
  }
}

class FeaturePoint extends StatelessWidget {
  final String data;
  const FeaturePoint({super.key, this.data = ""});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          size: 18.sp,
          color: colorScheme.primaryColor,
        ),
        XBox(4),
        Flexible(
          child: Text(
            data,
            style: textTheme.text12,
          ),
        ),
      ],
    );
  }
}
