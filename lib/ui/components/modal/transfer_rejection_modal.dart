import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class TransferRejectionModal extends ConsumerStatefulWidget {
  const TransferRejectionModal({super.key});

  @override
  ConsumerState<TransferRejectionModal> createState() =>
      _TransferRejectionModalState();
}

class _TransferRejectionModalState
    extends ConsumerState<TransferRejectionModal> {
  final TextEditingController reasonCtr = TextEditingController();

  @override
  void dispose() {
    reasonCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Reason for Rejection", style: textTheme.text16?.medium),
                  Text("Enter a reason for rejecting this request.",
                      style: textTheme.text12),
                ],
              ),
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
          CustomTextField(
            controller: reasonCtr,
            isRequired: false,
            labelText: 'Reason:',
            maxLines: 3,
            hintText: 'Enter reason',
            showLabelHeader: true,
            validator: Validators.required(),
            // onTap: () async {},
          ),
          YBox(16),
          CustomBtn(
            onTap: () async {
              if (reasonCtr.text.isEmpty) {
                showWarningToast('Provide reason for Rejecting Transfer');
              } else {
                Navigator.pop(NavKey.appNavKey.currentContext!, false);
                final response = await vm.updateTransferProduct("declined",
                    reason: reasonCtr.text);
                handleApiResponse(
                  response: response,
                  showSuccessToast: true,
                  onSuccess: () {
                    Navigator.pop(NavKey.appNavKey.currentContext!, false);
                  },
                );
              }
            },
            text: "Submit",
          )
        ],
      ),
    );
  }
}
