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
                  text: "Save",
                  onTap: () async {
                    ModalWrapper.bottomSheet(
                      context: context,
                      widget: CustomerReviewRespondModal(),
                    );
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
}
