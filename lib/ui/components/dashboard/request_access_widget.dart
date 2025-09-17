import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class RequestAccessWidget extends StatelessWidget {
  const RequestAccessWidget({
    super.key,
    this.onRequestAccess,
    this.isLoading = false,
  });

  final Function()? onRequestAccess;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.all(
        Sizer.radius(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.white,
          borderRadius: BorderRadius.circular(
            Sizer.radius(16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                YBox(16),
                EmptyListState(
                  fontSize: Sizer.text(14),
                  text:
                      "You are not authorized to access this page. Kindly request for access if you want to view this page",
                ),
                YBox(24),
                CustomBtn(
                  isLoading: isLoading,
                  width: Sizer.width(200),
                  text: "Request access",
                  onTap: onRequestAccess,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
