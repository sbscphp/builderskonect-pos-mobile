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
    final textTheme = Theme.of(context).textTheme;

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
          YBox(40),
          SvgPicture.asset(
            widget.modalConfirmationArg.iconPath,
            height: Sizer.height(80),
          ),
          YBox(16),
          Text(
            widget.modalConfirmationArg.title,
            style: textTheme.text20?.medium,
          ),
          YBox(4),
          Text(
            widget.modalConfirmationArg.description,
            textAlign: TextAlign.center,
            style: textTheme.text14,
          ),
          YBox(40),
          if (widget.modalConfirmationArg.isLoading)
            const BtnLoadState()
          else
            Column(
              children: [
                CustomBtn.solid(
                  text: widget.modalConfirmationArg.solidBtnText,
                  onTap: widget.modalConfirmationArg.onSolidBtnOnTap,
                ),
                if (widget.modalConfirmationArg.onOutlineBtnOnTap != null) ...[
                  const YBox(16),
                  CustomBtn.solid(
                    text: widget.modalConfirmationArg.outlineBtnText ??
                        "No, cancel",
                    isOutline: true,
                    outlineColor: AppColors.neutral5,
                    textStyle: textTheme.text16,
                    onTap: widget.modalConfirmationArg.onOutlineBtnOnTap,
                  ),
                ],
              ],
            ),
          YBox(30),
        ],
      ),
    );
  }
}
