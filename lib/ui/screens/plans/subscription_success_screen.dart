import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class SubscriptionSuccessScreen extends ConsumerStatefulWidget {
  const SubscriptionSuccessScreen({super.key, required this.arg});

  final SubscriptionSuccessArg arg;

  @override
  ConsumerState<SubscriptionSuccessScreen> createState() =>
      _SubscriptionSuccessScreenState();
}

class _SubscriptionSuccessScreenState
    extends ConsumerState<SubscriptionSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: AppColors.gray7F8,
      appBar: CustomAppbar(title: "", bgColor: AppColors.gray7F8),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: Sizer.width(16),
        ),
        children: [
          YBox(10),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Sizer.height(16),
              vertical: Sizer.height(24),
            ),
            width: Sizer.screenWidth,
            color: AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  AppImages.logo,
                  height: Sizer.height(40),
                  width: Sizer.width(90),
                  fit: BoxFit.cover,
                ),
                YBox(24),
                Text(
                  widget.arg.header,
                  style: textTheme.text20?.medium.copyWith(
                    color: colorScheme.primaryColor,
                  ),
                ),
                YBox(24),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizer.width(16),
                    vertical: Sizer.height(24),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius: BorderRadius.circular(Sizer.radius(16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichTextWidget(
                        content: widget.arg.content,
                        textAlign: TextAlign.left,
                        // maxLines: 5,
                        // overflow: TextOverflow.ellipsis,
                      ),
                      YBox(10),
                      CustomBtn(
                        height: 44,
                        borderRadius: BorderRadius.circular(Sizer.radius(8)),
                        text: widget.arg.btnText,
                        onTap: widget.arg.onTap,
                      ),
                    ],
                  ),
                ),
                YBox(24),
                Text(
                  "If you did not make this request, please email us at  ",
                  style: textTheme.text12,
                ),
                InkWell(
                  onTap: () {
                    AppUtils().launchEmail("support@builderskonnect.com");
                  },
                  child: Text(
                    "support@builderskonnect.com",
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.primaryColor,
                    ),
                  ),
                ),
                YBox(50),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        "+234 902 000 4555",
                        style: textTheme.text12,
                      ),
                      Text(
                        "www.buildershub.org",
                        style: textTheme.text12,
                      ),
                      Text(
                        "12b Alexandre, Ikoyi, Lagos",
                        style: textTheme.text12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
