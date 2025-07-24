import 'package:builders_konnect/core/core.dart';

class ScreenNotFound extends StatelessWidget {
  final String? routeName;

  const ScreenNotFound({this.routeName, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Page Not Found',
          style: textTheme.text20,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              '404 - Page Not Found',
              style: Theme.of(context).textTheme.text24,
            ),
            const SizedBox(height: 8),
            const Text(
              'The requested page could not be found',
              style: TextStyle(fontSize: 16),
            ),
            if (routeName != null) ...[
              const SizedBox(height: 8),
              Text(
                'Attempted route: $routeName',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 16.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () => Navigator.pushReplacementNamed(
                    context, RoutePath.bottomNavScreen),
                child: const Text(
                  'Return to Home',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
