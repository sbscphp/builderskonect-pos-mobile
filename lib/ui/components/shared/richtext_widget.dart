import 'package:builders_konnect/core/core.dart';

class RichTextWidget extends StatelessWidget {
  final String content;
  final TextStyle? contentStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? textScaleFactor;

  const RichTextWidget({
    super.key,
    required this.content,
    this.contentStyle,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.textScaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return _buildRichText(context);
  }

  Widget _buildRichText(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final baseStyle = contentStyle ??
        textTheme.text14!.copyWith(
          fontWeight: FontWeight.w400,
          color: colorScheme.black85,
          height: 1.5,
        );

    final boldStyle = baseStyle.copyWith(fontWeight: FontWeight.bold);

    List<TextSpan> spans = [];
    List<String> lines = content.split('\n');

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];

      // Add line break between lines (except before the first line)
      if (i > 0) {
        spans.add(TextSpan(text: '\n', style: baseStyle));
      }

      // If line is empty, continue to next iteration (line break already added above)
      if (line.trim().isEmpty) {
        continue;
      }

      line = line.trim();

      // Handle bullet points
      if (line.startsWith('•')) {
        spans.add(TextSpan(text: '• ', style: baseStyle));
        String restOfLine = line.substring(1).trim();

        // Parse bold text within the line
        _parseBoldText(restOfLine, spans, baseStyle, boldStyle);
      } else {
        // Parse bold text for non-bullet lines
        _parseBoldText(line, spans, baseStyle, boldStyle);
      }
    }

    return RichText(
      text: TextSpan(children: spans),
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      textScaler: TextScaler.linear(textScaleFactor ?? 1.0),
    );
  }

  void _parseBoldText(
    String text,
    List<TextSpan> spans,
    TextStyle baseStyle,
    TextStyle boldStyle,
  ) {
    // This method should contain your bold text parsing logic
    // Since it's not provided in the original code, here's a basic implementation
    // that assumes bold text is wrapped in **text** format

    final RegExp boldRegex = RegExp(r'\*\*(.*?)\*\*');
    int lastIndex = 0;
    bool foundBoldText = false;

    for (final Match match in boldRegex.allMatches(text)) {
      foundBoldText = true;
      
      // Add text before the bold part
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: baseStyle,
        ));
      }

      // Add the bold text
      spans.add(TextSpan(
        text: match.group(1) ?? '',
        style: boldStyle,
      ));

      lastIndex = match.end;
    }

    if (foundBoldText) {
      // Add remaining text after the last bold part
      if (lastIndex < text.length) {
        spans.add(TextSpan(
          text: text.substring(lastIndex),
          style: baseStyle,
        ));
      }
    } else {
      // If no bold text was found, add the entire text with base style
      spans.add(TextSpan(text: text, style: baseStyle));
    }
  }
}

// Usage example:
// RichTextWidget(
//   content: "This is **bold** text with bullet points:\n• First item\n• **Bold** second item",
//   contentStyle: TextStyle(fontSize: 16),
//   textAlign: TextAlign.left,
//   maxLines: 5,
//   overflow: TextOverflow.ellipsis,
// )
