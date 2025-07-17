import 'package:builders_konnect/core/core.dart';

class PricingTab extends StatefulWidget {
  final bool isYearly;
  final ValueChanged<bool> onChanged;

  const PricingTab({
    super.key,
    required this.isYearly,
    required this.onChanged,
  });

  @override
  State<PricingTab> createState() => _PricingTabState();
}

class _PricingTabState extends State<PricingTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Set initial state without triggering animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isYearly) {
        _controller.value = 1.0;
      } else {
        _controller.value = 0.0;
      }
    });
  }

  @override
  void didUpdateWidget(PricingTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isYearly != widget.isYearly) {
      if (widget.isYearly) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTabTapped(bool isYearly) {
    if (isYearly != widget.isYearly) {
      if (isYearly) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      widget.onChanged(isYearly);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabWidth = Sizer.width(100);
    final spacing = Sizer.width(16);
    final totalWidth = (tabWidth * 2) + spacing;

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: Sizer.height(52),
      decoration: BoxDecoration(
        color: AppColors.dayBreakBlue,
        borderRadius: BorderRadius.circular(Sizer.radius(40)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(10),
        vertical: Sizer.height(8),
      ),
      child: SizedBox(
        width: totalWidth,
        height: Sizer.height(36),
        child: Stack(
          children: [
            // Animated background indicator
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Positioned(
                  left: _animation.value * (tabWidth + spacing),
                  top: 0,
                  child: Container(
                    width: tabWidth,
                    height: Sizer.height(36),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(Sizer.radius(21)),
                    ),
                  ),
                );
              },
            ),
            // Tab buttons
            Row(
              children: [
                // Monthly tab
                Expanded(
                  child: InkWell(
                    onTap: () => _onTabTapped(false),
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        final isSelected = !widget.isYearly;
                        final opacity = isSelected ? 1.0 : 0.7;
                        final scale = isSelected ? 1.0 : 0.95;

                        return Transform.scale(
                          scale: scale,
                          child: SizedBox(
                            height: Sizer.height(36),
                            child: Center(
                              child: AnimatedOpacity(
                                opacity: opacity,
                                duration: const Duration(milliseconds: 200),
                                child: Text(
                                  "Monthly",
                                  style: textTheme.text12?.medium.copyWith(
                                    color: isSelected
                                        ? colorScheme.white
                                        : colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: spacing),
                // Yearly tab
                Expanded(
                  child: InkWell(
                    onTap: () => _onTabTapped(true),
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        final isSelected = widget.isYearly;
                        final opacity = isSelected ? 1.0 : 0.7;
                        final scale = isSelected ? 1.0 : 0.95;

                        return Transform.scale(
                          scale: scale,
                          child: SizedBox(
                            height: Sizer.height(36),
                            child: Center(
                              child: AnimatedOpacity(
                                opacity: opacity,
                                duration: const Duration(milliseconds: 200),
                                child: Text(
                                  "Yearly",
                                  style: textTheme.text12?.medium.copyWith(
                                    color: isSelected
                                        ? colorScheme.white
                                        : colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
