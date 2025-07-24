import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class DocumentUpload extends StatefulWidget {
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const DocumentUpload({
    super.key,
    this.onNext,
    this.onPrevious,
  });

  @override
  State<DocumentUpload> createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<DocumentUpload> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(
              top: Sizer.height(30),
              bottom: Sizer.height(60),
            ),
            children: [
              Container(
                padding: EdgeInsets.all(Sizer.radius(8)),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.yellow8F),
                  borderRadius: BorderRadius.circular(Sizer.radius(4)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.yellow3D,
                    ),
                    XBox(8),
                    Expanded(
                      child: Text(
                        "Skip the document upload process if you do not have the documents",
                        style: textTheme.text12?.copyWith(
                          color: AppColors.neutral8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              YBox(24),
              CustomTextField(
                isRequired: false,
                labelText: 'CAC Number',
                hintText: 'Enter CAC number',
                showLabelHeader: true,
              ),
              YBox(20),
              UploadWidget(
                documentName: "buildershub CAC.pdf",
                buttomTextDesc:
                    "Upload a copy of your Corporate Affairs Commission Certificate",
              ),
              YBox(20),
              CustomTextField(
                isRequired: true,
                labelText: 'TIN Number',
                hintText: 'Enter TIN number',
                showLabelHeader: true,
                keyboardType: TextInputType.number,
              ),
              YBox(20),
              UploadWidget(
                documentName: "buildershub CAC.pdf",
                buttomTextDesc:
                    "Upload a copy of your Tax Identification Certificate",
              ),
              YBox(20),
              UploadWidget(
                labelText: 'Proof of Address',
                documentName: "buildershub CAC.pdf",
                buttomTextDesc:
                    "Upload a copy of your utility bill for proof of address",
              ),
              YBox(40),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Skip",
                      style: textTheme.text16?.copyWith(
                        color: colorScheme.primaryColor,
                      ),
                    )),
              )
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CustomBtn.solid(
                isOutline: true,
                outlineColor: AppColors.neutral5,
                textStyle: textTheme.text16,
                text: "Previous",
                onTap: widget.onPrevious ?? () {},
              ),
            ),
            XBox(20),
            Expanded(
              child: CustomBtn.solid(
                text: "Next",
                onTap: widget.onNext ?? () {},
              ),
            ),
          ],
        ),
        YBox(10),
      ],
    );
  }
}

class UploadWidget extends StatelessWidget {
  const UploadWidget({
    super.key,
    this.documentName,
    this.buttomTextDesc,
    this.labelText,
    this.onUpload,
    this.onRemove,
  });

  final String? documentName;
  final String? buttomTextDesc;
  final String? labelText;
  final VoidCallback? onUpload;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                labelText ?? "Certificate",
                style: textTheme.text14,
              ),
              YBox(6),
              if (documentName != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizer.width(16),
                    vertical: Sizer.height(10),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.neutral5),
                    borderRadius: BorderRadius.circular(Sizer.radius(2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(AppSvgs.attachment),
                      XBox(8),
                      Expanded(
                        child: Text(documentName!,
                            style: textTheme.text14?.copyWith(
                              color: colorScheme.primaryColor,
                            )),
                      ),
                      InkWell(
                        onTap: onRemove,
                        child: SvgPicture.asset(AppSvgs.delete),
                      ),
                    ],
                  ),
                )
              else
                InkWell(
                  onTap: onUpload,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Sizer.width(16),
                      vertical: Sizer.height(16),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.neutral5),
                      borderRadius: BorderRadius.circular(Sizer.radius(2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(AppSvgs.upload),
                        XBox(8),
                        Text(
                          "Click to upload certificate",
                          style: textTheme.text14,
                        ),
                      ],
                    ),
                  ),
                ),
              if (buttomTextDesc != null)
                Padding(
                  padding: EdgeInsets.only(
                    top: Sizer.height(4),
                  ),
                  child: Text(
                    buttomTextDesc!,
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
