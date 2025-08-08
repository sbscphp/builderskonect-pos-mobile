// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ViewUploadScreen extends ConsumerStatefulWidget {
  const ViewUploadScreen({super.key});

  @override
  ConsumerState<ViewUploadScreen> createState() => _ViewUploadScreenState();
}

class _ViewUploadScreenState extends ConsumerState<ViewUploadScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppbar(
        title: "View Upload",
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YBox(30),
            Text(
              "Cement.jpg",
              style: textTheme.text16,
            ),
            YBox(24),
            ClipRRect(
              borderRadius: BorderRadius.circular(Sizer.radius(2)),
              child: Container(
                height: Sizer.height(393),
                width: Sizer.screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizer.radius(2)),
                ),
                child: MyCachedNetworkImage(
                  imageUrl: "https://picsum.photos/200/300",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            YBox(24),
            Row(
              children: [
                Expanded(
                  child: CustomBtn.solid(
                    text: "Delete",
                    onlineColor: AppColors.red22,
                    height: 48,
                    onTap: () {},
                  ),
                ),
                XBox(16),
                Expanded(
                  child: CustomBtn.solid(
                    text: "Change Upload",
                    onlineColor: colorScheme.white,
                    textColor: colorScheme.black85,
                    height: 48,
                    onTap: () {},
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
