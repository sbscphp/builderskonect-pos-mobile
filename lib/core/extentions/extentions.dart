extension StringExtensions on String {
  String get capitalizeFirst => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str[0].toUpperCase() + str.substring(1))
      .join(" ");
}
