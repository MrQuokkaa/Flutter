import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeData _themeData;
  late String _themeName;
  late Brightness _brightness;

  ThemeProvider(this._themeData, this._themeName, this._brightness);

  ThemeData get themeData => _themeData;
  String get themeName => _themeName;
  Brightness get brightness => _brightness;

  Future<void> setTheme(String themeName, {Brightness? brightness}) async {
    _themeName = themeName;
    _brightness = brightness ?? _brightness;

    final preset = getThemePreset(themeName);
    _themeData = buildCustomTheme(preset: preset, brightness: _brightness);

    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', themeName);
    await prefs.setString('brightness', _brightness.name);
  }

  static Future<ThemeProvider> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString('theme') ?? 'Blue';
    final brightnessString = prefs.getString('brightness') ?? 'light';
    final brightness = brightnessString == 'dark' ? Brightness.dark : Brightness.light;

    final preset = getThemePreset(themeName);
    final themeData = buildCustomTheme(preset: preset, brightness: brightness);

    return ThemeProvider(themeData, themeName, brightness);
  }
}
