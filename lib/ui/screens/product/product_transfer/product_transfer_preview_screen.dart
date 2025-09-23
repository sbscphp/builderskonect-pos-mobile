import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ProductTransferPreviewScreen extends ConsumerStatefulWidget {
  const ProductTransferPreviewScreen({super.key});

  @override
  ConsumerState<ProductTransferPreviewScreen> createState() =>
      _ProductTransferPreviewScreenState();
}

class _ProductTransferPreviewScreenState
    extends ConsumerState<ProductTransferPreviewScreen> {
  final storeC = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      storeC.text = ref.read(productTransferVm).selectedStore?.name ?? '';
      setState(() {});
    });
  }

  @override
  void dispose() {
    storeC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final vm = ref.watch(productTransferVm);

    return Scaffold(
      appBar: CustomAppbar(
        title: "Product Transfers",
      ),
      body: SizedBox(
        height: Sizer.screenHeight,
        width: Sizer.screenWidth,
        child: BusyOverlay(
          show: vm.busy(createState),
          child: ListView(
              padding: EdgeInsets.only(
                left: Sizer.width(16),
                right: Sizer.width(16),
                bottom: Sizer.height(50),
              ),
              children: [
                YBox(16),
                Container(
                  height: Sizer.screenHeight * 0.8,
                  padding: EdgeInsets.all(Sizer.radius(16)),
                  decoration: BoxDecoration(
                    color: colorScheme.white,
                    borderRadius: BorderRadius.circular(Sizer.radius(4)),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      FilterHeader(
                        title: "Preview Request Form",
                      ),
                      YBox(16),
                      CustomTextField(
                        labelText: "Send Request To",
                        labelFontWeight: FontWeight.w700,
                        enabled: false,
                        isRequired: false,
                        controller: storeC,
                      ),
                      YBox(16),
                      FilterHeader(
                        title: "Product List and Quantity",
                      ),
                      YBox(16),
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: vm.productList.length,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (_, __) => HDivider(),
                        itemBuilder: (ctx, i) {
                          final product = vm.productList[i];
                          final ctr = TextEditingController(
                              text: product.requestQuantity?.toString() ?? "0");
                          return TransferProductWidget(
                            productTitle: product.name ?? '',
                            subTitle: product.productType ?? '',
                            productImage: product.primaryMediaUrl ?? '',
                            sku: product.sku ?? '',
                            onChanged: (p0) {},
                            controller: ctr,
                            enabled: false,
                            showStock:
                                false, //todo: handle when data is available
                          );
                        },
                      ),
                      YBox((vm.productList.isEmpty) ? 300 : 100),
                      CustomBtn(
                        text: "Send Request",
                        online: vm.productList.isNotEmpty,
                        onTap: () {
                          ModalWrapper.bottomSheet(
                            context: context,
                            widget: ConfirmationModal(
                              modalConfirmationArg: ModalConfirmationArg(
                                iconPath: AppSvgs.infoCircle,
                                title: "Send Request",
                                description:
                                    "Are you sure you want to send this request. This cannot be undone after approval from the receiving store.",
                                solidBtnText: "Yes Submit",
                                isLoading: vm.busy(createState),
                                onSolidBtnOnTap: () async {
                                  Navigator.pop(context, true);
                                  final response =
                                      await vm.createProductTransfer();

                                  handleApiResponse(
                                    response: response,
                                    onSuccess: () {
                                      ModalWrapper.bottomSheet(
                                        context: context,
                                        // canDismiss: false,
                                        widget: ConfirmationModal(
                                          modalConfirmationArg:
                                              ModalConfirmationArg(
                                            iconPath: AppSvgs.checkIcon,
                                            title:
                                                "Transfer Request Successfully Sent",
                                            description:
                                                "A Request Code has been generated for this transfer.#${vm.createRequestModel?.reference ?? "000"}",
                                            solidBtnText: "Okay, good",
                                            onSolidBtnOnTap: () {
                                              // Get navigation context safely
                                              final navCtx = NavKey
                                                  .appNavKey.currentContext;
                                              if (navCtx == null) return;

                                              Navigator.pop(navCtx);
                                              Navigator.pop(navCtx);
                                              Navigator.pop(navCtx);
                                              Navigator.pop(navCtx);

                                              // Navigator.pushReplacementNamed(
                                              //   navCtx,
                                              //   RoutePath.productTransferScreen,
                                              // );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                onOutlineBtnOnTap: () {
                                  Navigator.pop(context, false);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
