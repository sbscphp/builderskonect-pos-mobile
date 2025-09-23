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
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    // final customerVm = ref.watch(customerVmodel);
    return Scaffold(
      appBar: CustomAppbar(
        title: "View Review",
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
              borderRadius: BorderRadius.circular(Sizer.radius(4)),
            ),
            child: Column(
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
                  // controller: respnseC,
                  isRequired: false,
                  labelText: 'Reply:',
                  hintText: 'Write here',
                  maxLines: 10,
                  showLabelHeader: true,
                ),
                YBox(24),
                CustomBtn.solid(
                  text: "Reply",
                  onTap: () async {
                    ModalWrapper.bottomSheet(
                      context: context,
                      widget: ConfirmationModal(
                        modalConfirmationArg: ModalConfirmationArg(
                          iconPath: AppSvgs.infoCircle,
                          title: "Send Response",
                          description:
                              "Are you sure you want to send a response to this customer review? This cannot be undone after it is sent.",
                          solidBtnText: "Yes, send",
                          onSolidBtnOnTap: () {
                            final ctx = NavKey.appNavKey.currentContext!;
                            Navigator.pop(ctx);
                          },
                          onOutlineBtnOnTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                ),
                YBox(30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
