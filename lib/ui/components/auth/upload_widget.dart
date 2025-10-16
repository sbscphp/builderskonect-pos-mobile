import 'package:builders_konnect/core/core.dart';
import 'package:flutter/cupertino.dart';

class UploadWidget extends StatelessWidget {
  const UploadWidget({
    super.key,
    this.documentName,
    this.buttomTextDesc,
    this.labelText,
    this.uploadText,
    this.isUploading = false,
    this.onUpload,
    this.onRemove,
  });

  final String? documentName;
  final String? buttomTextDesc;
  final String? labelText;
  final String? uploadText;
  final bool isUploading;
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
                Row(
                  children: [
                    Expanded(
                      child: Container(
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
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.text14?.copyWith(
                                    color: colorScheme.primaryColor,
                                  )),
                            ),
                            XBox(16),
                            InkWell(
                              onTap: !isUploading ? onRemove : null,
                              child: SvgPicture.asset(AppSvgs.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isUploading) XBox(10),
                    if (isUploading) CupertinoActivityIndicator()
                  ],
                )
              else
                Row(
                  children: [
                    InkWell(
                      onTap: !isUploading ? onUpload : null,
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
                              uploadText ?? "Click to upload certificate",
                              style: textTheme.text14,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    if (isUploading) CupertinoActivityIndicator()
                  ],
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
