class WebViewArg {
  final String? appBarText;
  final String webURL;
  final Function()? onBackPress;
  final Function()? onSucecess;

  WebViewArg({
    this.appBarText,
    required this.webURL,
    this.onBackPress,
    this.onSucecess,
  });
}
