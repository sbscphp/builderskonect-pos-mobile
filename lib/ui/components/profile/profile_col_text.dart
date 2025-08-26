import 'package:builders_konnect/core/core.dart';

class ProfileColText extends StatelessWidget {
  const ProfileColText({
    super.key,
    required this.title,
    this.title2,
    this.subTitle,
    this.subTitleWidget,
    this.onCopy,
  });

  final String title;
  final String? title2;
  final String? subTitle;
  final Widget? subTitleWidget;
  final Function()? onCopy;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorSheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: textTheme.text12?.copyWith(
              color: AppColors.grey175,
            ),
            children: [
              TextSpan(text: title),
              if (title2 != null)
                TextSpan(
                  text: title2!,
                  style: textTheme.text12?.copyWith(
                    color: colorSheme.primaryColor,
                  ),
                ),
            ],
          ),
        ),
        YBox(4),
        Row(
          children: [
            if (onCopy != null)
              InkWell(
                onTap: onCopy,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: Sizer.width(4),
                  ),
                  child: SvgPicture.asset(AppSvgs.copy),
                ),
              ),
            Expanded(
              child: subTitleWidget ??
                  Text(
                    subTitle ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.text14?.medium.copyWith(
                      color: AppColors.black23,
                    ),
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
