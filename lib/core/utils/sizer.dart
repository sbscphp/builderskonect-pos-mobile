import 'package:builders_konnect/core/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Sizer {
  static double get screenWidth => 1.sw;
  static double get screenHeight => 1.sh;
  static get deviceRatio => screenHeight / screenWidth;
  static height(double height) => height.h;
  static width(double width) => width.w;
  static text(double size, {applySizer = true}) => applySizer ? size.sp : size;
  static radius(double size) => size.r;
}

class XBox extends StatelessWidget {
  final double _width;

  const XBox(this._width, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width.w,
    );
  }
}

///Use for height spacing
class YBox extends StatelessWidget {
  final double _height;

  const YBox(this._height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height.h,
    );
  }
}

class HLine extends StatelessWidget {
  const HLine({
    super.key,
    this.height,
    this.color,
  });

  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizer.height(height ?? 1),
      width: Sizer.screenWidth,
      color: color ?? AppColors.neutral4,
    );
  }
}
