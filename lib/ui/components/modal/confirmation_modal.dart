import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ConfirmationModal extends ConsumerStatefulWidget {
  const ConfirmationModal({
    super.key,
    required this.modalConfirmationArg,
  });

  final ModalConfirmationArg modalConfirmationArg;

  @override
  ConsumerState<ConfirmationModal> createState() => _ConfirmationModalState();
}

class _ConfirmationModalState extends ConsumerState<ConfirmationModal> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          YBox(6),
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(AppSvgs.modalHLine),
          ),
          YBox(30),
          SvgPicture.asset(
            widget.modalConfirmationArg.iconPath,
            height: Sizer.height(80),
          ),
          YBox(16),
          Text(
            widget.modalConfirmationArg.title,
            style: AppTypography.text20.medium,
          ),
          YBox(4),
          Text(
            widget.modalConfirmationArg.description,
            textAlign: TextAlign.center,
            style: AppTypography.text14,
          ),
          YBox(40),
          CustomBtn.solid(
            text: "Okay, continue",
            onTap: () {},
          ),
          if (widget.modalConfirmationArg.onOutlineBtnOnTap != null) YBox(16),
          if (widget.modalConfirmationArg.onOutlineBtnOnTap != null)
            CustomBtn.solid(
              text: widget.modalConfirmationArg.outlineBtnText ?? "No, cancel",
              isOutline: true,
              outlineColor: AppColors.neutral5,
              textStyle: AppTypography.text16
                  .withCustomColor(AppColors.black.withValues(alpha: 0.85)),
              onTap: widget.modalConfirmationArg.onOutlineBtnOnTap,
            ),
          YBox(30),
        ],
      ),
    );
  }
}
