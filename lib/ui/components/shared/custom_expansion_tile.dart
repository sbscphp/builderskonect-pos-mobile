import 'package:builders_konnect/core/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomExpansionTile extends StatefulWidget {
  final Widget primaryChild;
  final Widget secondaryChild;
  final bool? initiallyExpanded;
  final bool showSuffixIcon;
  final ValueChanged<bool>? onExpansionChanged;
  final GlobalKey? containerKey;
  final Color? bgColor;
  final Color? borderColor;
  final EdgeInsets? padding;
  final bool useBoxShadow;
  final Color? iconColor;
  final double? paddingBtw;

  const CustomExpansionTile(
      {super.key,
      required this.primaryChild,
      required this.secondaryChild,
      this.initiallyExpanded = false,
      this.showSuffixIcon = true,
      this.onExpansionChanged,
      this.containerKey,
      this.borderColor,
      this.bgColor,
      this.padding,
      this.useBoxShadow = true,
      this.iconColor,
      this.paddingBtw});

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;

  @override
  void initState() {
    _isExpanded = widget.initiallyExpanded!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding ??
          EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      key: widget.containerKey,
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.all(Radius.circular(16.r)),
        boxShadow: widget.useBoxShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.051),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.102),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
              if (widget.onExpansionChanged != null)
                widget.onExpansionChanged!(_isExpanded);
            },
            child: Row(
              children: [
                Expanded(child: widget.primaryChild),
                if (widget.showSuffixIcon) SizedBox(width: 20.w),
                if (widget.showSuffixIcon)
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 25,
                    color: widget.iconColor ??
                        Theme.of(
                          context,
                        ).colorScheme.text6.withValues(alpha: 0.85),
                  ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Padding(
              padding: EdgeInsets.only(top: widget.paddingBtw ?? 16.h),
              child: widget.secondaryChild,
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
