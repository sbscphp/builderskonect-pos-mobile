import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class CustomerReviewModal extends ConsumerStatefulWidget {
  const CustomerReviewModal({
    super.key,
    required this.review,
  });

  final ReviewsModel review;

  @override
  ConsumerState<CustomerReviewModal> createState() =>
      _CustomerReviewModalState();
}

class _CustomerReviewModalState extends ConsumerState<CustomerReviewModal> {
  final respnseC = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      respnseC.text = widget.review.response ?? "";
      setState(() {});
    });
  }

  @override
  void dispose() {
    respnseC.dispose();
    super.dispose();
  }

  bool get hasResonse => widget.review.response != null;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
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
                "Customer Review",
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
            "View customer review on a product",
            style: textTheme.text12?.copyWith(
              color: AppColors.grey85,
            ),
          ),
          YBox(8),
          HDivider(verticalPadding: 0),
          YBox(20),
          Container(
            padding: EdgeInsets.all(Sizer.radius(16)),
            decoration: BoxDecoration(
              color: AppColors.neutral3,
              borderRadius: BorderRadius.circular(Sizer.radius(4)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomerReviewListTile(
                  image: "",
                  leadWidget: SvgPicture.asset(
                    AppSvgs.circleAvatar,
                    height: Sizer.height(24),
                  ),
                  title: widget.review.customerName ?? "",
                  subTitle: "Id: ",
                  subTitle2: widget.review.customerId ?? "N/A",
                  rating: double.tryParse(
                    widget.review.ratings ?? "0",
                  ),
                  date: widget.review.feedbackDate == null
                      ? "N/A"
                      : AppUtils.dayWithSuffixMonthAndYear(
                          widget.review.feedbackDate ?? DateTime.now(),
                        ),
                ),
                YBox(16),
                Text(
                  widget.review.feedback ?? "",
                  style: textTheme.text16,
                ),
              ],
            ),
          ),
          YBox(24),
          CustomTextField(
            controller: respnseC,
            isRequired: false,
            labelText: 'Response:',
            hintText: 'Write here',
            maxLines: 4,
            showLabelHeader: true,
            onChanged: (value) {
              setState(() {});
            },
          ),
          YBox(16),
          if (!hasResonse)
            Row(
              children: [
                Expanded(
                  child: CustomBtn.solid(
                    isOutline: true,
                    text: "Cancel",
                    textColor: colorScheme.black85,
                    onTap: () {},
                  ),
                ),
                XBox(16),
                Expanded(
                  child: CustomBtn.solid(
                    text: "Respond",
                    onTap: () async {
                      _sendRespond();
                    },
                  ),
                ),
              ],
            ),
          HDivider(),
          YBox(30),
        ],
      ),
    );
  }

  _sendRespond() {
    final loadingProvider = StateProvider<bool>((ref) => false);
    ModalWrapper.bottomSheet(
      context: context,
      widget: Consumer(
        builder: (context, ref, child) {
          final isLoading = ref.watch(loadingProvider);
          return ConfirmationModal(
            modalConfirmationArg: ModalConfirmationArg(
              iconPath: AppSvgs.infoCircle,
              title: "Send Response",
              description:
                  "Are you sure you want to send a response to this customer review? This cannot be undone after it is sent.",
              solidBtnText: "Yes, send",
              isLoading: isLoading,
              onSolidBtnOnTap: () async {
                final customVm = ref.read(customerVmodel);
                ref.read(loadingProvider.notifier).state = true;
                final ctx = NavKey.appNavKey.currentContext!;

                try {
                  final res = await customVm.sendResponse(
                    reviewId: widget.review.id ?? 0,
                    response: respnseC.text.trim(),
                  );
                  handleApiResponse(
                    response: res,
                    showSuccessToast: false,
                    onSuccess: () {
                      // Close the current modal first
                      if (context.mounted) {
                        Navigator.pop(ctx);
                      }

                      // Show success modal after a brief delay to prevent navigation conflicts
                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (ctx.mounted) {
                          ModalWrapper.bottomSheet(
                            context: ctx,
                            widget: ConfirmationModal(
                              modalConfirmationArg: ModalConfirmationArg(
                                iconPath: AppSvgs.checkIcon,
                                title: "Response Sent",
                                description:
                                    "The response has been sent \nsuccessfully.",
                                solidBtnText: "Okay",
                                onSolidBtnOnTap: () {
                                  final currentCtx =
                                      NavKey.appNavKey.currentContext!;
                                  Navigator.pop(currentCtx);
                                },
                              ),
                            ),
                          );
                        }
                      });
                    },
                  );
                } finally {
                  if (context.mounted) {
                    ref.read(loadingProvider.notifier).state = false;
                    Navigator.pop(ctx);
                  }
                }
              },
              onOutlineBtnOnTap: () {
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}
