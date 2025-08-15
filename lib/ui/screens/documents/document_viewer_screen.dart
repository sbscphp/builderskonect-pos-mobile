import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:path/path.dart' as path;
import 'package:webview_flutter/webview_flutter.dart';

class DocumentViewerScreen extends StatefulWidget {
  const DocumentViewerScreen({
    super.key,
    required this.arg,
  });

  final DocumentViewerArg arg;

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  bool isLoading = true;
  WebViewController? _controller;
  String? fileExtension;
  bool isImage = false;
  bool isPdf = false;
  bool isDoc = false;

  @override
  void initState() {
    super.initState();
    _determineFileType();
    if (isPdf || isDoc) {
      _initializeWebView();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _determineFileType() {
    final uri = Uri.parse(widget.arg.fileUrl);
    fileExtension = path.extension(uri.path).toLowerCase();

    // Image extensions
    if (['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp']
        .contains(fileExtension)) {
      isImage = true;
    }
    // PDF extension
    else if (fileExtension == '.pdf') {
      isPdf = true;
    }
    // Document extensions
    else if (['.doc', '.docx', '.txt', '.rtf'].contains(fileExtension)) {
      isDoc = true;
    }
    // Default to PDF viewer for unknown types
    else {
      isPdf = true;
    }
  }

  Future<void> _initializeWebView() async {
    try {
      String viewerUrl;

      if (isPdf) {
        // Use Google Docs viewer for PDFs
        viewerUrl =
            'https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(widget.arg.fileUrl)}';
      } else {
        // Use Google Docs viewer for documents
        viewerUrl =
            'https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(widget.arg.fileUrl)}';
      }

      _controller = WebViewController()
        ..loadRequest(Uri.parse(viewerUrl))
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              printty('Document viewer started loading: $url');
            },
            onPageFinished: (String url) {
              printty('Document viewer finished loading: $url');
              setState(() {
                isLoading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {
              printty('Error loading document: ${error.description}');
              setState(() {
                isLoading = false;
              });
            },
          ),
        );
    } catch (e) {
      printty('Error initializing document viewer: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppbar(
        title: widget.arg.appBarText ?? "Document Viewer",
        onBack: widget.arg.onBackPress,
      ),
      body: SizedBox(
        height: Sizer.screenHeight,
        child: BusyOverlay(
          show: isLoading,
          child: _buildContent(textTheme, colorScheme),
        ),
      ),
    );
  }

  Widget _buildContent(TextTheme textTheme, ColorScheme colorScheme) {
    if (isImage) {
      return _buildImageViewer();
    } else if (isPdf || isDoc) {
      return _buildDocumentViewer();
    } else {
      return _buildErrorView(textTheme);
    }
  }

  Widget _buildImageViewer() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: InteractiveViewer(
        panEnabled: true,
        boundaryMargin: const EdgeInsets.all(20),
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: MyCachedNetworkImage(
            imageUrl: widget.arg.fileUrl,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentViewer() {
    if (_controller == null) {
      return _buildErrorView(Theme.of(context).textTheme);
    }

    return WebViewWidget(controller: _controller!);
  }

  Widget _buildErrorView(TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Unable to load document',
            style: textTheme.text16?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'File type: ${fileExtension ?? 'Unknown'}',
            style: textTheme.text14?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
