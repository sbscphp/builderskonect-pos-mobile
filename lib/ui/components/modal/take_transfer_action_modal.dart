import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class TakeTransferActionModal extends ConsumerWidget {
  const TakeTransferActionModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final vm = ref.watch(productTransferVm);

    return Container(
      height: Sizer.screenHeight * 0.35,
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YBox(20),
          Row(
            children: [
              Text("Take Action", style: textTheme.text16?.medium),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: AppColors.black,
                  size: Sizer.radius(24),
                ),
              )
            ],
          ),
          YBox(16),
          Divider(color: AppColors.neutral4, height: 1),
          YBox(16),
          Text(
            "${vm.selectedActionProducts.length} Selected",
            style: textTheme.text16?.copyWith(),
          ),
          YBox(16),
          CustomBtn(
            onTap: () {
              Navigator.pop(context, true);
              ModalWrapper.bottomSheet(
                context: context,
                widget: ConfirmationModal(
                  modalConfirmationArg: ModalConfirmationArg(
                    iconPath: AppSvgs.infoCircle,
                    title: "Approve Transfer",
                    description:
                        "Are you sure you want to accept this stock transfer request? This action will mark the transfer request as accepted and adjust the stock levels. Do you want to proceed?",
                    solidBtnText: "Yes, approve",
                    // isLoading: vm.busy(createState),
                    onSolidBtnOnTap: () async {
                      Navigator.pop(NavKey.appNavKey.currentContext!);
                      final response =
                          await vm.updateTransferProduct("approved");
                      handleApiResponse(
                        response: response,
                        onSuccess: () {
                          ModalWrapper.bottomSheet(
                            context: NavKey.appNavKey.currentContext!,
                            canDismiss: false,
                            widget: ConfirmationModal(
                              modalConfirmationArg: ModalConfirmationArg(
                                iconPath: AppSvgs.checkIcon,
                                title: "Transfer Approved.",
                                description:
                                    "The requesting store will be notified of this transfer approval.",
                                solidBtnText: "Okay, good",
                                onSolidBtnOnTap: () {
                                  // Get navigation context safely
                                  final navCtx =
                                      NavKey.appNavKey.currentContext;
                                  if (navCtx == null) return;

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
                    onOutlineBtnOnTap: () {
                      Navigator.pop(NavKey.appNavKey.currentContext!, false);
                    },
                  ),
                ),
              );
            },
            text: "Approve",
          ),
          YBox(16),
          CustomBtn(
            onTap: () {
              Navigator.pop(context);
              ModalWrapper.bottomSheet(
                context: context,
                widget: ConfirmationModal(
                  modalConfirmationArg: ModalConfirmationArg(
                    iconPath: AppSvgs.infoCircleRed,
                    title: "Reject Transfer",
                    description:
                        "Are you sure you want to reject this stock transfer request?",
                    solidBtnText: "Yes, reject",
                    // isLoading: vm.busy(createState),
                    onSolidBtnOnTap: () async {
                      Navigator.pop(NavKey.appNavKey.currentContext!);
                      ModalWrapper.bottomSheet(
                          context: NavKey.appNavKey.currentContext!,
                          widget: TransferRejectionModal());
                    },
                    onOutlineBtnOnTap: () {
                      Navigator.pop(NavKey.appNavKey.currentContext!, false);
                    },
                  ),
                ),
              );
            },
            outlineColor: AppColors.grey,
            onlineColor: Colors.transparent,
            text: "Reject",
            textColor: AppColors.red2D,
          ),
        ],
      ),
    );
  }
}
