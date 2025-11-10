// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';

class ViewOrderReceiptScreen extends ConsumerStatefulWidget {
  const ViewOrderReceiptScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<ViewOrderReceiptScreen> createState() =>
      _ViewOrderReceiptScreenState();
}

class _ViewOrderReceiptScreenState extends ConsumerState<ViewOrderReceiptScreen>
    with TickerProviderStateMixin {
  bool showListOfItems = false;
  final GlobalKey _receiptBoundaryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(salesVmodel).getSalesOrderDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final salesVm = ref.watch(salesVmodel);
    final profileVm = ref.watch(vendorProfileVmodel);
    return Scaffold(
      appBar: CustomAppbar(
        title: "View receipt",
        trailingWidget: InkWell(
          onTap: () {
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(100, 100, 0, 0),
              items: [
                PopupMenuItem(
                  value: 'download_receipt',
                  child: Text('Download Receipt', style: textTheme.text14),
                ),
                PopupMenuItem(
                  value: 'share_receipt',
                  child: Text('Share Receipt', style: textTheme.text14),
                ),
              ],
            ).then((value) {
              if (value != null) {
                printty('Selected: $value');
                switch (value) {
                  case 'download_receipt':
                    _downloadReceipt();
                    break;
                  case 'share_receipt':
                    _shareReceipt();
                    break;

                  default:
                    break;
                }
              }
            });
          },
          child: SvgPicture.asset(
            AppSvgs.download,
            height: Sizer.height(24),
            width: Sizer.width(24),
          ),
        ),
      ),
      body: Builder(builder: (context) {
        if (salesVm.busy(viewState)) {
          return SizerLoader(
            height: double.infinity,
          );
        }
        if (salesVm.error(viewState)) {
          return ErrorState(
            onPressed: () {
              ref.read(salesVmodel).getSalesOrderDetails(widget.id);
            },
          );
        }
        return ListView(
          padding: EdgeInsets.only(
            bottom: Sizer.height(50),
          ),
          children: [
            YBox(16),
            RepaintBoundary(
              key: _receiptBoundaryKey,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
                padding: EdgeInsets.symmetric(
                  horizontal: Sizer.width(16),
                  vertical: Sizer.height(16),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizer.radius(4)),
                  color: colorScheme.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Sizer.height(40),
                      width: Sizer.width(100),
                      child: MyCachedNetworkImage(
                        imageUrl: profileVm.vendorProfile?.logo ?? "",
                        fit: BoxFit.cover,
                      ),
                    ),
                    YBox(16),
                    Text(
                        "Order #${salesVm.salesOrdersModel?.orderNumber ?? "N/A"}",
                        style: textTheme.text16?.medium),
                    Text(
                      "Receipt: N/A",
                      style: textTheme.text14,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Sizer.height(16)),
                      child: HLine(),
                    ),
                    YBox(8),
                    BuildRowText(
                      leftText: "Sales Type:",
                      rightText:
                          salesVm.salesOrdersModel?.salesType?.toUpperCase() ??
                              "N/A",
                    ),
                    YBox(8),
                    BuildRowText(
                      leftText: "Payment Status:",
                      rightText:
                          salesVm.salesOrdersModel?.paymentStatus ?? "N/A",
                    ),
                    YBox(8),
                    BuildRowText(
                      leftText: "Order Status:",
                      rightText: salesVm.salesOrdersModel?.status ?? "N/A",
                    ),
                    YBox(8),
                    BuildRowText(
                      leftText: "Payment Method:",
                      rightText: salesVm
                              .salesOrdersModel?.paymentMethods?.first.method ??
                          "N/A",
                    ),
                    YBox(8),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Sizer.height(16)),
                      child: HLine(),
                    ),
                    YBox(8),
                    Text("Customer Information",
                        style: textTheme.text14?.medium),
                    YBox(8),
                    BuildRowText(
                      leftText: "Customer Name:",
                      rightText:
                          salesVm.salesOrdersModel?.customer?.name ?? "N/A",
                    ),
                    YBox(8),
                    BuildRowText(
                      leftText: "Email:",
                      rightText:
                          salesVm.salesOrdersModel?.customer?.email ?? "N/A",
                    ),
                    YBox(8),
                    BuildRowText(
                      leftText: "Phone Number:",
                      rightText:
                          salesVm.salesOrdersModel?.customer?.phone ?? "N/A",
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Sizer.height(16)),
                      child: HLine(),
                    ),
                    Text("Items", style: textTheme.text14?.medium),
                    YBox(16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount:
                          salesVm.salesOrdersModel?.lineItems?.length ?? 0,
                      separatorBuilder: (_, __) => Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Sizer.height(8)),
                        child: HDivider(),
                      ),
                      itemBuilder: (ctx, i) {
                        final lineItem =
                            salesVm.salesOrdersModel?.lineItems?[i];
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 200 + (i * 50)),
                          curve: Curves.easeOutBack,
                          child: SaleDetailsListTile(
                            productImage: lineItem?.productMediaUrl ?? "",
                            productTitle: lineItem?.product ?? "",
                            subTitle: lineItem?.productType ?? "",
                            sku: lineItem?.productSku ?? "",
                            price: lineItem?.unitCost?.toString() ?? "",
                            totalAmount: lineItem?.totalCost?.toString() ?? "",
                            quantity: lineItem?.quantity?.toString() ?? "",
                            discount:
                                lineItem?.discountedAmount?.toString() ?? "",
                          ),
                        );
                      },
                    ),
                    YBox(8),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Sizer.height(16)),
                      child: HLine(),
                    ),
                    YBox(8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizer.width(16),
                        vertical: Sizer.height(20),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.neutral3,
                        borderRadius: BorderRadius.circular(Sizer.radius(8)),
                      ),
                      child: Column(
                        children: [
                          PlansRowText(
                            keyText: 'Subtotal',
                            valueText: salesVm.salesOrdersModel?.subtotal ?? "",
                          ),
                          YBox(14),
                          PlansRowText(
                            keyText: 'Discount',
                            valueText: salesVm.salesOrdersModel
                                    ?.discountBreakdown?.orderDiscount ??
                                "",
                          ),
                          YBox(14),
                          PlansRowText(
                            keyText:
                                "VAT (${salesVm.salesOrdersModel?.fees?.tax} VAT)",
                            valueText: salesVm.salesOrdersModel?.fees?.tax
                                    ?.toString() ??
                                "N/A",
                          ),
                          YBox(14),
                          PlansRowText(
                            keyText: "Service fee",
                            valueText: salesVm
                                    .salesOrdersModel?.fees?.serviceFee
                                    ?.toString() ??
                                "N/A",
                          ),
                          YBox(14),
                          PlansRowText(
                            keyText: "Delivery Fee",
                            valueText: salesVm
                                    .salesOrdersModel?.fees?.deliveryFee
                                    ?.toString() ??
                                "N/A",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Future<Uint8List?> _captureReceiptPng() async {
    try {
      final boundary = _receiptBoundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      printty('Error capturing receipt: $e');
      return null;
    }
  }

  Future<void> _downloadReceipt() async {
    try {
      // Request access to save into Photos/Gallery
      await Gal.requestAccess();
      final bytes = await _captureReceiptPng();
      if (bytes == null) {
        showWarningToast('Unable to capture receipt');
        return;
      }
      await Gal.putImageBytes(bytes);
      showSuccessToastMessage('Receipt saved to gallery');
    } on GalException catch (e) {
      showWarningToast(e.type.message);
    } catch (e) {
      showWarningToast('Failed to save receipt');
      printty('Download receipt error: $e');
    }
  }

  Future<void> _shareReceipt() async {
    try {
      final bytes = await _captureReceiptPng();
      if (bytes == null) {
        showWarningToast('Unable to capture receipt');
        return;
      }
      final orderNumber =
          ref.read(salesVmodel).salesOrdersModel?.orderNumber ?? 'receipt';
      final xFile = XFile.fromData(bytes,
          name: 'receipt_$orderNumber.png', mimeType: 'image/png');
      await Share.shareXFiles([xFile], text: 'Receipt #$orderNumber');
    } catch (e) {
      showWarningToast('Failed to share receipt');
      printty('Share receipt error: $e');
    }
  }
}

class BuildRowText extends StatelessWidget {
  const BuildRowText({
    super.key,
    required this.leftText,
    required this.rightText,
  });

  final String leftText;
  final String rightText;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftText,
          style: textTheme.text14?.copyWith(
            color: AppColors.grey70,
          ),
        ),
        Text(
          rightText,
          style: textTheme.text14,
        ),
      ],
    );
  }
}
