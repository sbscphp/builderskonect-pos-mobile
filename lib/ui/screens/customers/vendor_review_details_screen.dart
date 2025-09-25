import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class VendorReviewDetailsScreen extends ConsumerStatefulWidget {
  const VendorReviewDetailsScreen({
    super.key,
    required this.review,
  });

  final ReviewsModel review;

  @override
  VendorReviewDetailsScreenState createState() =>
      VendorReviewDetailsScreenState();
}

class VendorReviewDetailsScreenState
    extends ConsumerState<VendorReviewDetailsScreen> {
  final respnseC = TextEditingController();
  ReviewsModel? review;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetch();
    });
  }

  _fetch() {
    ref
        .read(customerVmodel)
        .viewReview(reviewId: widget.review.id ?? 0)
        .then((value) {
      if (value.success) {
        review = value.data;
        respnseC.text = review?.response ?? '';
        setState(() {});
      }
    });
  }

  bool get hasResponse => review?.response != null;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final customerVm = ref.watch(customerVmodel);
    return Scaffold(
      appBar: CustomAppbar(
        title: "View Review",
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetch();
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
                borderRadius: BorderRadius.circular(Sizer.radius(4)),
              ),
              child: Builder(builder: (context) {
                if (customerVm.busy(viewState)) {
                  return SizerLoader(height: 600);
                }

                if (customerVm.error(viewState)) {
                  return SizedBox(
                    height: Sizer.height(600),
                    child: Center(
                      child: ErrorState(
                        onPressed: () {
                          _fetch();
                        },
                      ),
                    ),
                  );
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                    widget.review.feedbackDate ??
                                        DateTime.now(),
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
                      labelText: hasResponse ? "Response" : 'Reply:',
                      hintText: 'Write here',
                      maxLines: 10,
                      showLabelHeader: true,
                    ),
                    YBox(24),
                    if (!hasResponse)
                      CustomBtn.solid(
                        text: "Reply",
                        onTap: () async {
                          _sendRespond();
                        },
                      ),
                    YBox(30),
                  ],
                );
              }),
            ),
          ],
        ),
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
                      _fetch();
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
