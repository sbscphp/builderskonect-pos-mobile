import 'dart:io';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ProfileTopWidget extends ConsumerStatefulWidget {
  const ProfileTopWidget({
    super.key,
    required this.avatarUrl,
    required this.storeName,
    required this.email,
    required this.phone,
  });

  final String avatarUrl;
  final String storeName;
  final String email;
  final String phone;

  @override
  ConsumerState<ProfileTopWidget> createState() => _ProfileTopWidgetState();
}

class _ProfileTopWidgetState extends ConsumerState<ProfileTopWidget> {
  File? _imageFile;
  String? _imageUrl;
  bool loadingImage = false;
  bool _uploadsComplete = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
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
          InkWell(
            onTap: () async {
              await _pickImages();
            },
            child: CustomCircleAvatar(
              isLoading: loadingImage,
              size: 60,
              avatarUrl: widget.avatarUrl,
            ),
          ),
          XBox(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.storeName,
                  style: textTheme.text16?.medium,
                ),
                YBox(2),
                Row(
                  children: [
                    SvgPicture.asset(AppSvgs.mail),
                    XBox(8),
                    Expanded(
                      child: Text(
                        widget.email,
                        maxLines: 1,
                        style: textTheme.text16?.copyWith(
                          color: AppColors.neutral9,
                        ),
                      ),
                    ),
                  ],
                ),
                YBox(2),
                Row(
                  children: [
                    SvgPicture.asset(AppSvgs.phone),
                    XBox(8),
                    Text(
                      widget.phone,
                      style: textTheme.text16?.copyWith(
                        color: AppColors.neutral9,
                      ),
                    ),
                  ],
                ),
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

      final pickedFile = await ImageAndDocUtils.pickImage(enableCropping: true);

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
