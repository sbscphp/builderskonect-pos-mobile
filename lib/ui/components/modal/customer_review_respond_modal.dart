import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class CustomerReviewRespondModal extends ConsumerStatefulWidget {
  const CustomerReviewRespondModal({super.key});

  @override
  ConsumerState<CustomerReviewRespondModal> createState() =>
      _CustomerReviewRespondModalState();
}

class _CustomerReviewRespondModalState
    extends ConsumerState<CustomerReviewRespondModal> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YBox(16),
          Row(
            children: [
              Text(
                "Respond",
                style: textTheme.text16?.medium,
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.close,
                  size: Sizer.width(24),
                ),
              )
            ],
          ),
          YBox(4),
          Text(
            "Enter a response to the customer review",
            style: textTheme.text12?.copyWith(
              color: AppColors.grey85,
            ),
          ),
          YBox(8),
          HDivider(verticalPadding: 0),
          YBox(20),
          CustomTextField(
            // controller: _emailController,
            isRequired: false,
            labelText: 'Response:',
            hintText: 'Enter your email',
            maxLines: 4,
            showLabelHeader: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {});
            },
          ),
          YBox(16),
          CustomBtn.solid(
            text: "Send response",
            onTap: () async {
              ModalWrapper.bottomSheet(
                context: context,
                widget: ConfirmationModal(
                  modalConfirmationArg: ModalConfirmationArg(
                    iconPath: AppSvgs.infoCircle,
                    title: "Send Response",
                    description:
                        "Are you sure you want to send a response to this customer review? This cannot be undone after it is sent.",
                    solidBtnText: "Okay",
                    onSolidBtnOnTap: () {
                      Navigator.pop(context);
                    },
                    onOutlineBtnOnTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
          ),
          HDivider(),
          YBox(30),
        ],
      ),
    );
  }
}
