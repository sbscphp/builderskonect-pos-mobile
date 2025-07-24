import 'package:builders_konnect/core/core.dart';

class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onPressed;
  final bool isPaginationType;
  final Color? textColor;
  final Color? buttonColor;
  final Color? buttonTextColor;
  const ErrorState(
      {super.key,
      this.textColor,
      this.buttonColor,
      this.buttonTextColor,
      this.message = 'An Error Occurred',
      required this.onPressed,
      this.isPaginationType = false});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (isPaginationType == true) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500, color: colorScheme.black45),
            ),
            SizedBox(
              width: 8.w,
            ),
            ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 13.h, horizontal: 24.w),
                  elevation: 0,
                  backgroundColor: buttonColor ?? colorScheme.black45,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
                child: Text(
                  'Retry',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: buttonTextColor ?? Colors.white,
                  ),
                ) // Button's label
                )
          ],
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500, color: colorScheme.black25),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15.h,
          ),
          ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 24.w),
                elevation: 0,
                backgroundColor: buttonColor ?? colorScheme.black45,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              child: Text(
                'Retry',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: buttonTextColor ?? Colors.white,
                ),
                textAlign: TextAlign.center,
              ) // Button's label
              )
        ],
      ),
    );
  }
}
