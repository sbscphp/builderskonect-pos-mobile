import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class DottedUpload extends StatelessWidget {
  const DottedUpload({
    super.key,
    required this.label,
    this.isUploading = false,
    this.isCoverImage = true,
    this.onTap,
  });
  final String label;
  final bool isUploading;
  final bool isCoverImage;
  final VoidCallback? onTap;
  
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.text14,
        ),
        YBox(6),
        isUploading
            ? Container(
                height: Sizer.height(104),
                decoration: BoxDecoration(
                  color: AppColors.neutral2,
                  border: Border.all(
                    color: AppColors.neutral5,
                  ),
                  borderRadius: BorderRadius.circular(Sizer.radius(4)),
                ),
                child: Center(
                  child: SpinKitLoader(
                    size: Sizer.height(35),
                    color: AppColors.neutral5,
                  ),
                ),
              )
            : InkWell(
                onTap: onTap,
                child: SvgPicture.asset(
                  isCoverImage ? AppSvgs.dottedCover : AppSvgs.dottedUpload,
                  height: Sizer.height(104),
                ),
              ),
      ],
    );
  }
}
