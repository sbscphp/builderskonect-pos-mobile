class SubscriptionSuccessArg {
  final String header;
  final String content;
  final String btnText;
  final Function() onTap;

  SubscriptionSuccessArg({
    required this.header,
    required this.content,
    required this.btnText,
    required this.onTap,
  });
}
