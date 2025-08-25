import 'dart:ui';

import 'package:builders_konnect/core/core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BusyOverlay extends StatefulWidget {
  final Widget child;
  final bool show;

  const BusyOverlay({
    super.key,
    required this.child,
    this.show = false,
  });

  @override
  State<BusyOverlay> createState() => _BusyOverlayState();
}

class _BusyOverlayState extends State<BusyOverlay> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: Sizer.screenWidth,
        height: Sizer.screenWidth,
        child: Stack(
          children: <Widget>[
            widget.child,
            Visibility(
              visible: widget.show,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 10, sigmaY: 10), // Adjust the blur intensity
                child: Container(
                  color: AppColors.mischkaGrey.withValues(alpha: 0.3),
                ),
              ),
            ),
            Center(
              child: IgnorePointer(
                ignoring: !widget.show,
                child: Visibility(
                  visible: widget.show,
                  child: const SpinKitLoader(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SizerLoader extends StatelessWidget {
  const SizerLoader({
    super.key,
    this.height,
  });

  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizer.height(height ?? 200),
      child: const Center(
        child: SpinKitLoader(
          size: 40,
          color: AppColors.neutral5,
        ),
      ),
    );
  }
}

class SpinKitLoader extends StatelessWidget {
  const SpinKitLoader({super.key, this.size, this.color});
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitSpinningCircle(
        size: size ?? 50, //200
        itemBuilder: (BuildContext context, int i) {
          return Image.asset(AppImages.bk, color: color);
        },
      ),
    );
  }
}
