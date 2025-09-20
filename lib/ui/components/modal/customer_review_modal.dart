import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class CustomerReviewModal extends ConsumerStatefulWidget {
  const CustomerReviewModal({super.key});

  @override
  ConsumerState<CustomerReviewModal> createState() =>
      _CustomerReviewModalState();
}

class _CustomerReviewModalState extends ConsumerState<CustomerReviewModal> {
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
              children: [
                CustomerReviewListTile(
                  productImage: "https://picsum.photos/200/300",
                  leadWidget: SvgPicture.asset(
                    AppSvgs.circleAvatar,
                    height: Sizer.height(24),
                  ),
                  productName: "Adeboyega Boyega",
                  productType: "Product Type",
                  date: "2023-01-01",
                  rating: 4,
                  onTap: () {
                    ModalWrapper.bottomSheet(
                      context: context,
                      widget: CustomerReviewModal(),
                    );
                  },
                ),
                YBox(16),
                Text(
                  "A design system for enterprise-level products. Create an efficient and enjoyable work experience.",
                  style: textTheme.text16,
                ),
              ],
            ),
          ),
          YBox(24),
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
