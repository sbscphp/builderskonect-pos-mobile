import 'package:builders_konnect/core/core.dart';

class InfoContainer extends StatelessWidget {
  const InfoContainer({
    super.key,
    this.show = false,
    required this.title,
    required this.content,
    this.onTap,
  });

  final bool show;
  final String title;
  final String content;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(
        Sizer.radius(12),
      ),
      decoration: BoxDecoration(
        color: colorScheme.white,
        border: Border.all(color: AppColors.yellow3D),
        borderRadius: BorderRadius.circular(Sizer.radius(4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  AppSvgs.reviewIcon,
                  height: Sizer.height(32),
                ),
                XBox(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.text14?.medium,
                      ),
                      YBox(2),
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        crossFadeState: show
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: Text(
                          content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.text12,
                        ),
                        secondChild: Text(
                          content,
                          style: textTheme.text12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          XBox(10),
          GestureDetector(
            onTap: onTap,
            child: AnimatedRotation(
              turns: show ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Icon(
                Icons.keyboard_arrow_down,
                size: Sizer.width(24),
              ),
            ),
          )
        ],
      ),
    );
  }
}
