import 'dart:io';

import 'package:builders_konnect/core/core.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyCachedNetworkImage extends StatefulWidget {
  const MyCachedNetworkImage({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.errorUrl,
    this.fadeInDuration,
    this.imageUrl,
  });
  final double? width, height;
  final BoxFit fit;
  final Duration? fadeInDuration;
  final String? imageUrl, errorUrl;
  @override
  State<MyCachedNetworkImage> createState() => _MyCachedNetworkImageState();
}

class _MyCachedNetworkImageState extends State<MyCachedNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return (widget.imageUrl == null || (widget.imageUrl?.isEmpty ?? false))
        ? Image.asset(
            AppImages.noimage,
            fit: BoxFit.cover,
          )
        : (Platform.isIOS)
            ? FadeInImage.assetNetwork(
                imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                  AppImages.noimage,
                  fit: widget.fit,
                  width: widget.width,
                  height: widget.height,
                ),
                placeholder: widget.errorUrl ?? AppImages.noimage,
                image: widget.imageUrl ?? AppImages.noimage,
                fit: widget.fit,
                width: widget.width,
                fadeInDuration:
                    widget.fadeInDuration ?? const Duration(milliseconds: 50),
                height: widget.height,
              )
            : CachedNetworkImage(
                cacheKey: widget.imageUrl,
                imageUrl: widget.imageUrl ?? '',
                fadeInDuration: const Duration(milliseconds: 50),
                fit: widget.fit,
                width: widget.width,
                height: widget.height,
                errorWidget: (context, url, error) => Image.asset(
                  AppImages.noimage,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
                placeholder: (context, url) => Image.asset(
                  AppImages.noimage,
                  fit: widget.fit,
                  width: widget.width,
                  height: widget.height,
                ),
              );
  }
}
