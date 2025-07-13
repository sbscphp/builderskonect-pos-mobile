import 'dart:ui';

import 'package:builders_konnect/core/core.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
                    sigmaX: 12, sigmaY: 12), // Adjust the blur intensity
                child: Container(
                  color: Colors.black12.withOpacity(
                    0.3,
                  ), // Adjust the background color and opacity
                ),
              ),
            ),
            Center(
              child: IgnorePointer(
                ignoring: !widget.show,
                child: Visibility(
                  visible: widget.show,
                  child: const LoaderIcon(),
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
        child: LoaderIcon(size: 40),
      ),
    );
  }
}

class LoaderIcon extends StatelessWidget {
  const LoaderIcon({
    super.key,
    this.size,
    this.color,
  });

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.fourRotatingDots(
      color: color ?? AppColors.primaryBlue,
      size: Sizer.radius(size ?? 50),
    );
  }
}

// class SpinKitLoader extends StatelessWidget {
//   const SpinKitLoader({super.key, this.size});
//   final double? size;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SpinKitSpinningCircle(
//         size: size ?? 30, //200
//         itemBuilder: (BuildContext context, int index) {
//           return Container(
//             height: Sizer.height(10),
//             width: Sizer.height(10),
//             color: index.isEven ? AppColors.primaryBlue : AppColors.blue5,
//           );
//         },
//       ),
//     );
//   }
// }
