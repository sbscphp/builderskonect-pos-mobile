class ModalConfirmationArg {
  final String iconPath;
  final String title;
  final String description;
  final String solidBtnText;
  final String? outlineBtnText;
  final Function()? onSolidBtnOnTap;
  final Function()? onOutlineBtnOnTap;

  ModalConfirmationArg({
    required this.iconPath,
    required this.title,
    required this.description,
    required this.solidBtnText,
    this.outlineBtnText,
    this.onSolidBtnOnTap,
    this.onOutlineBtnOnTap,
  });
}
