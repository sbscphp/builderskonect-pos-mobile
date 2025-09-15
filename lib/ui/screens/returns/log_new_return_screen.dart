// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class LogNewReturnScreen extends ConsumerStatefulWidget {
  const LogNewReturnScreen({super.key});

  @override
  ConsumerState<LogNewReturnScreen> createState() => _LogNewReturnScreenState();
}

class _LogNewReturnScreenState extends ConsumerState<LogNewReturnScreen> {
  final formKey = GlobalKey<FormState>();
  final customerC = TextEditingController();
  final orderIdC = TextEditingController();
  final reasonC = TextEditingController();
  final descriptionC = TextEditingController();

  Timer? _debounce;
  bool searchingCustomersOrder = false;
  bool showOrderDetails = false;

  final List<File> _imageFiles = [];
  final List<String> _uploadedUrls = [];
  bool loadingImage = false;
  bool _uploadsComplete = false;

  CustomerData? selectedCustomer;
  SalesData? selectedOrder;
  List<SaleDetailsLineItem> selectedLineItems = [];
  Map<String, TextEditingController> qtyControllers = {};
  Map<String, String> returnQuantities = {};

  @override
  void dispose() {
    customerC.dispose();
    orderIdC.dispose();
    reasonC.dispose();
    descriptionC.dispose();
    _debounce?.cancel();
    // Dispose all quantity controllers
    for (var controller in qtyControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Search with debounce
  void _searchOrderId(String query, String customerId) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(salesVmodel).getSalesOverview(
            q: query.trim(),
            customerId: customerId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final salesVm = ref.watch(salesVmodel);
    return BusyOverlay(
      show: ref.watch(refundReturnsVm).busy(createState),
      child: Scaffold(
          appBar: CustomAppbar(
            title: "Log New Returns",
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
                  borderRadius: BorderRadius.circular(Sizer.radius(6)),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Log New Returns", style: textTheme.text16?.medium),
                      Text(
                        "Fill the form below to log a new product return.",
                        style: textTheme.text12?.copyWith(
                          color: colorScheme.black45,
                        ),
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: customerC,
                        labelText: 'Customer',
                        hintText: 'Enter customer',
                        showLabelHeader: true,
                        readOnly: true,
                        validator: Validators.required(),
                        suffixIcon: Padding(
                          padding: EdgeInsets.all(Sizer.width(10)),
                          child: SvgPicture.asset(AppSvgs.search),
                        ),
                        onTap: () async {
                          final res = await ModalWrapper.bottomSheet(
                              context: context, widget: SelectCustomerModal());

                          if (res is CustomerData) {
                            customerC.text = res.name ?? '';
                            selectedCustomer = res;
                          }
                          setState(() {});
                        },
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: orderIdC,
                        labelText: 'Order ID',
                        hintText: 'Enter order ID',
                        showLabelHeader: true,
                        readOnly: selectedCustomer == null,
                        validator: Validators.required(),
                        onChanged: (val) {
                          searchingCustomersOrder = true;
                          _searchOrderId(val, selectedCustomer?.id ?? '');
                        },
                        onTap: selectedCustomer != null
                            ? null
                            : () {
                                showWarningToast("Please select a customer");
                                return;
                              },
                      ),
                      AnimatedSize(
                        duration: Duration(milliseconds: 500),
                        child: Builder(builder: (context) {
                          if (!searchingCustomersOrder) {
                            return SizedBox.shrink();
                          }

                          if (salesVm.busy(getState)) {
                            return SizerLoader(
                              height: Sizer.height(300),
                            );
                          }
                          return Container(
                            margin: EdgeInsets.only(top: Sizer.height(8)),
                            padding: EdgeInsets.all(Sizer.height(16)),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  BorderRadius.circular(Sizer.radius(2)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            constraints: BoxConstraints(
                              maxHeight: Sizer.height(300),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(
                                top: Sizer.height(14),
                              ),
                              itemCount: salesVm.salesData.length,
                              separatorBuilder: (_, __) => HDivider(),
                              itemBuilder: (ctx, i) {
                                final data = salesVm.salesData[i];
                                return CustomColWidget(
                                  firstColText: "#${data.orderNumber ?? ""}",
                                  subTitle: "Total items: ",
                                  subTitle2: data.itemsCount?.toString() ?? "",
                                  status: data.status ?? "",
                                  date: data.orderDate?.toLocal(),
                                  onTap: () {
                                    selectedOrder = data;
                                    orderIdC.text = data.orderNumber ?? '';
                                    searchingCustomersOrder = false;
                                    showOrderDetails = true;
                                    ref
                                        .read(salesVmodel)
                                        .getSalesOrderDetails(data.id ?? "0");
                                  },
                                );
                              },
                            ),
                          );
                        }),
                      ),
                      AnimatedSize(
                        duration: Duration(milliseconds: 500),
                        child: Builder(builder: (context) {
                          if (!showOrderDetails) {
                            return SizedBox.shrink();
                          }

                          if (salesVm.busy(viewState)) {
                            return SizerLoader(
                              height: Sizer.height(300),
                            );
                          }
                          return Container(
                            margin: EdgeInsets.only(top: Sizer.height(8)),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  BorderRadius.circular(Sizer.radius(2)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            constraints: BoxConstraints(
                              maxHeight: Sizer.height(300),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(
                                top: Sizer.height(16),
                                bottom: Sizer.height(30),
                              ),
                              itemCount:
                                  salesVm.salesOrdersModel?.lineItems?.length ??
                                      0,
                              separatorBuilder: (_, __) => HDivider(),
                              itemBuilder: (ctx, i) {
                                final lineItem =
                                    salesVm.salesOrdersModel?.lineItems?[i];
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Sizer.width(16),
                                  ),
                                  child: RetrunOrderListTile(
                                    productTitle: lineItem?.product ?? '',
                                    subTitle: lineItem?.productType ?? '',
                                    productImage:
                                        lineItem?.productMediaUrl ?? '',
                                    sku: lineItem?.productSku ?? '',
                                    amount: lineItem?.totalCost ?? '',
                                    qty: lineItem?.quantity?.toString() ?? '',
                                    showQtyTextfield:
                                        selectedLineItems.contains(lineItem),
                                    isSelected:
                                        selectedLineItems.contains(lineItem),
                                    qtyController: qtyControllers[
                                        lineItem?.lineItemId ?? ''],
                                    onQtyChanged: (value) {
                                      returnQuantities[
                                          lineItem?.lineItemId ?? ''] = value;
                                    },
                                    onSelect: () {
                                      if (selectedLineItems
                                          .contains(lineItem)) {
                                        selectedLineItems.remove(lineItem);
                                        qtyControllers
                                            .remove(lineItem?.lineItemId);
                                        returnQuantities
                                            .remove(lineItem?.lineItemId);
                                      } else {
                                        selectedLineItems.add(lineItem!);
                                        qtyControllers[lineItem.lineItemId ??
                                            ''] = TextEditingController();
                                      }
                                      setState(() {});
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: reasonC,
                        labelText: 'Reason for Return',
                        hintText: 'Enter reason for return',
                        showLabelHeader: true,
                        readOnly: true,
                        showSuffixIcon: true,
                        validator: Validators.required(),
                        onTap: () async {
                          final res = await ModalWrapper.bottomSheet(
                              context: context, widget: SelectReasonModal());

                          if (res is String && res.isNotEmpty) {
                            reasonC.text = res;
                          }
                          setState(() {});
                        },
                      ),
                      YBox(16),
                      if (_imageFiles.isNotEmpty)
                        SizedBox(
                          height: Sizer.height(104),
                          width: Sizer.screenWidth,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _imageFiles.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(right: Sizer.width(8)),
                                    width: Sizer.width(200),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Sizer.radius(8)),
                                      image: DecorationImage(
                                        image: FileImage(_imageFiles[index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Positioned(
                                  //   top: 0,
                                  //   left: 0,
                                  //   right: 0,
                                  //   bottom: 0,
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.center,
                                  //     children: [
                                  //       InkWell(
                                  //         onTap: () {
                                  //           Navigator.pushNamed(context,
                                  //               RoutePath.viewUploadScreen);
                                  //         },
                                  //         child: Container(
                                  //           padding: EdgeInsets.symmetric(
                                  //             horizontal: Sizer.width(16),
                                  //             vertical: Sizer.height(4),
                                  //           ),
                                  //           decoration: BoxDecoration(
                                  //             color: AppColors.white,
                                  //             borderRadius: BorderRadius.circular(
                                  //                 Sizer.radius(4)),
                                  //           ),
                                  //           child: Text(
                                  //             "View image",
                                  //             style: textTheme.text14,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // )
                                ],
                              );
                            },
                          ),
                        ),
                      YBox(16),
                      Text(
                        "Upload Images",
                        style: textTheme.text14,
                      ),
                      YBox(8),
                      InkWell(
                        onTap: _pickImages,
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: Sizer.height(104),
                                  width: Sizer.screenWidth,
                                  child: SvgPicture.asset(
                                    AppSvgs.uploadImg,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                YBox(4),
                                Text(
                                  "Recommended file size is less than 2MB. JEPG, PNG formats only",
                                  style: textTheme.text12?.copyWith(
                                    color: colorScheme.black45,
                                  ),
                                ),
                              ],
                            ),
                            if (loadingImage)
                              Positioned(
                                right: 0,
                                left: 0,
                                child: Container(
                                  height: Sizer.height(104),
                                  width: Sizer.screenWidth,
                                  decoration: BoxDecoration(
                                    color: AppColors.neutral2,
                                  ),
                                  child: SpinKitLoader(
                                      color: AppColors.neutral5, size: 40),
                                ),
                              ),
                          ],
                        ),
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: descriptionC,
                        labelText: 'Description',
                        hintText: 'Enter description',
                        maxLines: 3,
                        isRequired: false,
                        showLabelHeader: true,
                      ),
                      YBox(20),
                      CustomBtn.solid(
                        text: "Log return(s)",
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            _logRefunds();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  _logRefunds() async {
    // Validate that all selected line items have return quantities
    bool hasValidQuantities = true;
    for (var lineItem in selectedLineItems) {
      final qtyController = qtyControllers[lineItem.lineItemId];
      if (qtyController == null || qtyController.text.isEmpty) {
        hasValidQuantities = false;
        break;
      }
      final returnQty = int.tryParse(qtyController.text);
      final maxQty = int.tryParse(lineItem.quantity?.toString() ?? '0') ?? 0;
      if (returnQty == null || returnQty <= 0 || returnQty > maxQty) {
        hasValidQuantities = false;
        break;
      }
    }

    if (!hasValidQuantities) {
      showWarningToast(
          'Please enter valid return quantities for all selected items');
      return;
    }

    final refundVm = ref.read(refundReturnsVm);

    final result = await ModalWrapper.bottomSheet(
      context: context,
      widget: ConfirmationModal(
        modalConfirmationArg: ModalConfirmationArg(
          iconPath: AppSvgs.infoCircle,
          title: "Log New Return(s)",
          description:
              "Are you sure you want to log this return to the record? This return will be recorded for action by the admin.",
          solidBtnText: "Yes, log new return",
          onSolidBtnOnTap: () {
            Navigator.pop(context, true);
          },
          onOutlineBtnOnTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );

    printty("result $result");

    if (result is bool && result) {
      // Create separate return requests for each line item
      bool allSuccessful = true;
      for (var lineItem in selectedLineItems) {
        final qtyController = qtyControllers[lineItem.lineItemId];
        final returnQty = qtyController?.text ?? '0';
        final unitPrice = (double.tryParse(lineItem.totalCost ?? '0') ?? 0) /
            (int.tryParse(lineItem.quantity?.toString() ?? '1') ?? 1);
        final refundAmount = unitPrice * (int.tryParse(returnQty) ?? 0);

        final res = await refundVm.createReturns(ReturnParams(
          userId: selectedCustomer?.id ?? "",
          orderId: selectedOrder?.id ?? '',
          returnReason: reasonC.text.trim(),
          description: descriptionC.text,
          orderLineItemId: lineItem.lineItemId ?? '',
          totalAmountRefunded: refundAmount.toString(),
          quantity: returnQty,
          media: _uploadedUrls,
          refundType: "credit-note",
        ));

        handleApiResponse(
          response: res,
          showSuccessToast: false,
          onSuccess: () {
            ModalWrapper.bottomSheet(
              context: context,
              widget: ConfirmationModal(
                modalConfirmationArg: ModalConfirmationArg(
                  iconPath: AppSvgs.checkIcon,
                  title: "New Return(s) Logged",
                  description:
                      "This return(s) request has been logged for quick response. A return ID has also been generated for the new returns log.",
                  solidBtnText: "Okay, good",
                  onSolidBtnOnTap: () {
                    final ctx = NavKey.appNavKey.currentContext!;
                    Navigator.pop(ctx);
                    Navigator.pop(ctx);
                  },
                ),
              ),
            );
          },
        );
      }
    }
  }

  Future<void> _pickImages() async {
    setState(() {
      loadingImage = true;
      _uploadsComplete = false;
    });

    try {
      // Reset progress tracking for any previous uploads
      ref.read(fileUploadVm).resetProgress();

      final pickedFiles = await ImageAndDocUtils.pickMultipleImage();

      for (var pickedFile in pickedFiles) {
        setState(() => _imageFiles.add(File(pickedFile.path)));
      }

      if (_imageFiles.isNotEmpty) {
        final r = await ref.read(fileUploadVm).uploadFile(file: _imageFiles);
        if (r.success && r.data != null && r.data!.isNotEmpty) {
          printty("upload complete ${r.data!.first.url}");
          _uploadedUrls.addAll(r.data!.map((e) => e.url ?? ""));
          setState(() {
            _uploadsComplete = true;
          });
        }
      }
    } catch (e) {
      FlushBarToast.fLSnackBar(
          snackBarType: SnackBarType.warning, message: e.toString());
    } finally {
      setState(() => loadingImage = false);
    }
  }
}
