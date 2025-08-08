import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/shared/busy_overlay.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebviewScreen extends StatefulWidget {
  const CustomWebviewScreen({
    super.key,
    required this.arg,
  });

  final WebViewArg arg;

  @override
  State<CustomWebviewScreen> createState() => _CustomWebviewScreenState();
}

class _CustomWebviewScreenState extends State<CustomWebviewScreen> {
  bool isLoading = true;

  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    printty("urlParam ${widget.arg.webURL}");
    _initializeControllerFuture();
  }

  Future<void> _initializeControllerFuture() async {
    printty('Initializing WebViewController...');
    try {
      _controller = WebViewController()
        ..loadRequest(Uri.parse(widget.arg.webURL))
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              printty('Page started loading: $url');
            },
            onPageFinished: (String url) {
              printty('Page finished loading: $url');
              setState(() {
                isLoading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {
              printty('Error loading page: ${error.description}');
            },
            onNavigationRequest: (NavigationRequest request) async {
              printty("urlpadhere ${request.url}");
              if (request.url.contains('merchant.builderskonnect')) {
                // Add this line - prevents future callbacks from updating state
                _controller = null;

                if (widget.arg.onSucecess != null) {
                  widget.arg.onSucecess!();
                }

                return NavigationDecision
                    .prevent; // Prevent further navigation since we're leaving
              }
              return NavigationDecision.navigate;
            },
          ),
        );
    } catch (e) {
      printty('Error initializing WebViewController: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Sizer.height(60)),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Sizer.width(16),
          ),
          color: AppColors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: widget.arg.onBackPress ?? () => Navigator.pop(context),
                child: Padding(
                  padding: EdgeInsets.all(Sizer.radius(4)),
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    size: Sizer.radius(30),
                  ),
                ),
              ),
              const YBox(10),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _controller ?? WebViewController(),
          ),
          if (isLoading)
            const Center(child: SpinKitLoader())
          else if (_controller == null)
            const Center(child: Text('Failed to load page')),
        ],
      ),
    );
  }
}
