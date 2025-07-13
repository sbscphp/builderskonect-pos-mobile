import 'package:builders_konnect/core/core.dart';

class ThemeViewModel extends BaseVm {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    reBuildUI();
  }

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    reBuildUI();
  }
}

final themeViewModel = ChangeNotifierProvider<ThemeViewModel>((ref) {
  return ThemeViewModel();
});
