class DocumentViewerArg {
  final String? appBarText;
  final String fileUrl;
  final String? fileName;
  final Function()? onBackPress;

  DocumentViewerArg({
    this.appBarText,
    required this.fileUrl,
    this.fileName,
    this.onBackPress,
  });
}