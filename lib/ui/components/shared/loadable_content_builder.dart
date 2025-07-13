import 'package:builders_konnect/core/core.dart';

class LoadableContentBuilder<T> extends StatelessWidget {
  final bool isBusy;
  final bool isError;
  final List<T>? items;
  final Widget Function(BuildContext) loadingBuilder;
  final Widget Function(BuildContext)? emptyBuilder;
  final Widget Function(BuildContext)? errorBuilder;
  final Widget Function(BuildContext) contentBuilder;

  const LoadableContentBuilder({
    super.key,
    required this.isBusy,
    this.isError = false,
    this.items,
    required this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    required this.contentBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (isBusy) {
      return loadingBuilder(context);
    }
    if (isError) {
      return errorBuilder?.call(context) ?? const SizedBox.shrink();
    }
    if (items == null) {
      return contentBuilder(context);
    }
    if (items!.isEmpty) {
      return emptyBuilder?.call(context) ?? const SizedBox.shrink();
    }

    // If items has content, call contentBuilder
    return contentBuilder(context);
  }
}
