import 'package:builders_konnect/core/core.dart';

class ProfileColText extends StatelessWidget {
  const ProfileColText({
    super.key,
    required this.title,
    this.subTitle,
    this.subTitleWidget,
    this.onCopy,
  });

  final String title;
  final String? subTitle;
  final Widget? subTitleWidget;
  final Function()? onCopy;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.text12?.copyWith(
            color: AppColors.grey175,
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
            Flexible(
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
