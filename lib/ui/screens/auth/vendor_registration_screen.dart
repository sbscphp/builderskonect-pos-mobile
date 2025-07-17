import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/core/themes/custom_text_theme.dart';
import 'package:builders_konnect/ui/components/components.dart';

class VendorRegistrationScreen extends StatefulWidget {
  const VendorRegistrationScreen({super.key});

  @override
  State<VendorRegistrationScreen> createState() =>
      _VendorRegistrationScreenState();
}

class _VendorRegistrationScreenState extends State<VendorRegistrationScreen> {
  int regSteps = 2;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        height: Sizer.screenHeight,
        width: Sizer.screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.signupBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              YBox(10),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: Sizer.height(16),
                    horizontal: Sizer.width(16),
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(Sizer.radius(8)),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          onTap: () {
                            if (regSteps > 1) {
                              regSteps--;
                            } else {
                              Navigator.pop(context);
                            }
                            setState(() {});
                          },
                          child: SvgPicture.asset(AppSvgs.circleBack),
                        ),
                      ),
                      YBox(20),
                      Text("Vendor Registration",
                          style: textTheme.text20?.medium
                          // style: AppTypography.text20.medium,
                          ),
                      YBox(24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RegSteps(
                            number: "1",
                            text: "Vendor Details",
                            isActive: true,
                          ),
                          XBox(6),
                          RegSteps(
                            number: "2",
                            text: "Bank Details",
                          ),
                          XBox(6),
                          RegSteps(
                            number: "3",
                            text: "Document Upload",
                          ),
                        ],
                      ),
                      YBox(10),
                      Expanded(
                        child: switch (regSteps) {
                          1 => VendorDetails(),
                          2 => BankDetails(),
                          _ => DocumentUpload(),
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
