import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class TagInputWidget extends StatefulWidget {
  const TagInputWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.onTagsChanged,
    this.initialTags = const [],
    this.showLabelHeader = true,
    this.isRequired = false,
    this.validator,
    this.helperText,
  });

  final String labelText;
  final String hintText;
  final Function(List<String>) onTagsChanged;
  final List<String> initialTags;
  final bool showLabelHeader;
  final bool isRequired;
  final String? Function(String?)? validator;
  final String? helperText;

  @override
  State<TagInputWidget> createState() => _TagInputWidgetState();
}

class _TagInputWidgetState extends State<TagInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.initialTags);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final trimmedTag = tag.trim();
    if (trimmedTag.isNotEmpty && !_tags.contains(trimmedTag)) {
      setState(() {
        _tags.add(trimmedTag);
      });
      _controller.clear();
      widget.onTagsChanged(_tags);
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
    widget.onTagsChanged(_tags);
  }

  void _onSubmitted(String? value) {
    if (value != null) {
      _addTag(value);
    }
  }

  String getTagsAsString() {
    return _tags.join(',');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _controller,
          focusNode: _focusNode,
          labelText: widget.labelText,
          hintText: widget.hintText,
          showLabelHeader: widget.showLabelHeader,
          isRequired: widget.isRequired,
          validator: widget.validator,
          onSubmit: _onSubmitted,
          onChanged: (value) {
            // Handle comma-separated input
            if (value.contains(',')) {
              final parts = value.split(',');
              if (parts.length > 1) {
                // Add all complete tags (except the last one which might be incomplete)
                for (int i = 0; i < parts.length - 1; i++) {
                  _addTag(parts[i]);
                }
                // Keep the last part in the text field
                _controller.text = parts.last;
                _controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: _controller.text.length),
                );
              }
            }
          },
        ),
        if (widget.helperText != null) ...[
          YBox(4),
          Text(
            widget.helperText!,
            style: textTheme.text14?.copyWith(
              color: colorScheme.black45,
            ),
          ),
        ],
        if (_tags.isNotEmpty) ...[
          YBox(12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tags.map((tag) {
              return TagWidget(
                tag: tag,
                showCloseIcon: true,
                onClose: () => _removeTag(tag),
                tagColor: TagColor(
                  bgColor: AppColors.dayBreakBlue,
                  borderColor: AppColors.dayBreakBlue3,
                  textColor: colorScheme.primaryColor,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
