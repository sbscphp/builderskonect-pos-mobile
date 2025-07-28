import 'package:builders_konnect/core/core.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({
    super.key,
    required this.title,
    this.isSelected = false,
    this.onTap,
  });

  final String title;
  final bool isSelected;
  final Function()? onTap;

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _borderAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _borderAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Set initial state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isSelected) {
        _controller.value = 1.0;
      } else {
        _controller.value = 0.0;
      }
    });
  }

  @override
  void didUpdateWidget(ProfileTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      if (widget.isSelected) {
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    _colorAnimation = ColorTween(
      begin: colorScheme.black85,
      end: colorScheme.primaryColor,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(Sizer.radius(8)),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: Sizer.height(16),
                horizontal: Sizer.width(8),
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: widget.isSelected
                        ? colorScheme.primaryColor
                        : Colors.transparent,
                    width: _borderAnimation.value,
                  ),
                ),
              ),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: textTheme.text14?.copyWith(
                      color: _colorAnimation.value,
                      fontWeight: widget.isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ) ??
                    const TextStyle(),
                child: Text(widget.title),
              ),
            ),
          );
        },
      ),
    );
  }
}
