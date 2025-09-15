import 'dart:io';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class WelcomeOnboardWidget extends ConsumerStatefulWidget {
  const WelcomeOnboardWidget({
    super.key,
  });

  @override
  ConsumerState<WelcomeOnboardWidget> createState() =>
      _WelcomeOnboardWidgetState();
}

class _WelcomeOnboardWidgetState extends ConsumerState<WelcomeOnboardWidget> {
  File? _imageFile;
  String? _imageUrl;
  bool loadingImage = false;
  bool _uploadsComplete = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final profileVm = ref.watch(vendorProfileVmodel);
    return Container(
      margin: EdgeInsets.only(
        top: Sizer.height(16),
        left: Sizer.width(16),
        right: Sizer.width(16),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(16),
        vertical: Sizer.height(16),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizer.radius(4)),
        color: colorScheme.white,
      ),
      child: Row(
        children: [
          CustomCircleAvatar(
            isLoading: loadingImage,
            size: 64,
            showBorder: (profileVm.vendorProfile?.logo ?? "").isEmpty,
            avatarUrl: _imageUrl ?? profileVm.vendorProfile?.logo ?? "",
          ),
          XBox(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome Onboard!',
                    style: textTheme.text16?.medium.copyWith(
                      color: AppColors.primaryBlue,
                    )),
                YBox(2),
                Text(
                  "Complete your business profile by uploading your business logo",
                  style: textTheme.text12?.copyWith(
                    color: AppColors.neutral8,
                  ),
                ),
                YBox(8),
                CustomBtn(
                  height: Sizer.height(38),
                  width: Sizer.width(90),
                  text: "Upload Logo",
                  isOutline: true,
                  textStyle: textTheme.text12?.copyWith(
                    color: AppColors.primaryBlue,
                  ),
                  onTap: () async {
                    await _pickImages();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _pickImages() async {
    setState(() {
      loadingImage = true;
      _uploadsComplete = false;
    });

    try {
      // Reset progress tracking for any previous uploads
      ref.read(fileUploadVm).resetProgress();

      final pickedFile = await ImageAndDocUtils.pickImage();

      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        setState(() {});
      }

      if (_imageFile != null) {
        final r = await ref.read(fileUploadVm).uploadFile(file: [_imageFile!]);
        if (r.success && r.data != null && r.data!.isNotEmpty) {
          printty("upload complete ${r.data!.first.url}");
          _imageUrl = r.data!.first.url;

          // update vendor profile
          await ref.read(vendorProfileVmodel).updateVendorProfile(
                VendorProfileParams(logo: _imageUrl),
              );

          _uploadsComplete = true;
          setState(() {});
        }
      }
    } catch (e) {
      showWarningToast(e.toString());
    } finally {
      setState(() => loadingImage = false);
    }
  }
}
