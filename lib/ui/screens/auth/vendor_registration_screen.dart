import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class VendorRegistrationScreen extends StatefulWidget {
  const VendorRegistrationScreen({super.key, required this.reference});

  final String reference;

  @override
  State<VendorRegistrationScreen> createState() =>
      _VendorRegistrationScreenState();
}

class _VendorRegistrationScreenState extends State<VendorRegistrationScreen> {
  int regSteps = 1;
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
                            isActive: regSteps == 1,
                          ),
                          XBox(6),
                          RegSteps(
                            number: "2",
                            text: "Bank Details",
                            isActive: regSteps == 2,
                          ),
                          XBox(6),
                          RegSteps(
                            number: "3",
                            text: "Document Upload",
                            isActive: regSteps == 3,
                          ),
                        ],
                      ),
                      YBox(10),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child: switch (regSteps) {
                            1 => VendorDetails(
                                key: const ValueKey('vendor_details'),
                                reference: widget.reference,
                                onNext: () {
                                  regSteps = 2;
                                  setState(() {});
                                },
                              ),
                            2 => BankDetails(
                                key: const ValueKey('bank_details'),
                                onNext: () {
                                  regSteps = 3;
                                  setState(() {});
                                },
                                onPrevious: () {
                                  regSteps = 1;
                                  setState(() {});
                                },
                              ),
                            _ => DocumentUpload(
                                key: const ValueKey('document_upload'),
                                onPrevious: () {
                                  setState(() {
                                    regSteps = 2;
                                  });
                                },
                              ),
                          },
                        ),
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
