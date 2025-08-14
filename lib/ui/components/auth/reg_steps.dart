import 'package:builders_konnect/core/core.dart';

class RegSteps extends StatefulWidget {
  const RegSteps({
    super.key,
    this.isActive = false,
    required this.number,
    required this.text,
  });

  final bool isActive;
  final String number;
  final String text;

  @override
  State<RegSteps> createState() => _RegStepsState();
}

class _RegStepsState extends State<RegSteps>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _backgroundColorAnimation;
  late Animation<Color?> _borderColorAnimation;
  late Animation<Color?> _textColorAnimation;
  late Animation<Color?> _numberColorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateAnimations();

    if (widget.isActive) {
      _animationController.forward();
    }
  }

  void _updateAnimations() {
    final colorScheme = Theme.of(context).colorScheme;

    _backgroundColorAnimation = ColorTween(
      begin: AppColors.transparent,
      end: AppColors.primaryBlue,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _borderColorAnimation = ColorTween(
      begin: AppColors.black.withValues(alpha: 0.25),
      end: AppColors.transparent,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _textColorAnimation = ColorTween(
      begin: colorScheme.black25,
      end: colorScheme.black85,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _numberColorAnimation = ColorTween(
      begin: colorScheme.black25,
      end: colorScheme.white,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(RegSteps oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isActive ? _scaleAnimation.value : 1.0,
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: Sizer.width(18),
                height: Sizer.height(18),
                decoration: BoxDecoration(
                  color: _backgroundColorAnimation.value,
                  borderRadius: BorderRadius.circular(Sizer.radius(20)),
                  border: Border.all(
                    color: _borderColorAnimation.value ?? AppColors.transparent,
                  ),
                  boxShadow: widget.isActive
                      ? [
                          BoxShadow(
                            color: AppColors.primaryBlue.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    style: textTheme.text12?.copyWith(
                          color: _numberColorAnimation.value,
                          fontSize: Sizer.text(11),
                        ) ??
                        const TextStyle(),
                    child: Text(widget.number),
                  ),
                ),
              ),
              XBox(6),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                style: textTheme.text12?.copyWith(
                      color: _textColorAnimation.value,
                      fontSize: Sizer.text(11),
                    ) ??
                    const TextStyle(),
                child: Text(widget.text),
              ),
            ],
          ),
        );
      },
    );
  }
}
