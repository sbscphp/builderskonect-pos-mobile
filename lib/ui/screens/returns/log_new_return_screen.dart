// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class LogNewReturnScreen extends ConsumerStatefulWidget {
  const LogNewReturnScreen({super.key});

  @override
  ConsumerState<LogNewReturnScreen> createState() => _LogNewReturnScreenState();
}

class _LogNewReturnScreenState extends ConsumerState<LogNewReturnScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: CustomAppbar(
          title: "Log New Returns",
        ),
        body: ListView(
          padding: EdgeInsets.only(
            left: Sizer.width(16),
            right: Sizer.width(16),
            bottom: Sizer.height(50),
          ),
          children: [
            YBox(16),
            Container(
              padding: EdgeInsets.all(Sizer.radius(16)),
              decoration: BoxDecoration(
                color: colorScheme.white,
                borderRadius: BorderRadius.circular(Sizer.radius(6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Log New Returns", style: textTheme.text16?.medium),
                  Text(
                    "Fill the form below to log a new product return.",
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                  YBox(16),
                  CustomTextField(
                    labelText: 'Customer',
                    hintText: 'Enter customer',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    labelText: 'Order ID',
                    hintText: 'Enter order ID',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    labelText: 'Reason for Return',
                    hintText: 'Enter reason for return',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  Text(
                    "Upload Images",
                    style: textTheme.text14,
                  ),
                  YBox(8),
                  SizedBox(
                    height: Sizer.height(104),
                    width: Sizer.screenWidth,
                    child: SvgPicture.asset(
                      AppSvgs.uploadImg,
                      fit: BoxFit.cover,
                    ),
                  ),
                  YBox(16),
                  CustomTextField(
                    labelText: 'Description',
                    hintText: 'Enter description',
                    maxLines: 3,
                    showLabelHeader: true,
                  ),
                  YBox(20),
                  CustomBtn.solid(
                    text: "Log return(s)",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
