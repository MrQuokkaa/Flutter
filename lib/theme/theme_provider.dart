import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;
  String _themeName;

  ThemeProvider(this._themeData, this._themeName);

  ThemeData get themeData => _themeData;
  String get themeName => _themeName;

  Future<void> setTheme(String themeName) async {
    _themeName = themeName;
    if (themeName == 'Light') {
      _themeData = lightTheme;
    } else if (themeName == 'Dark') {
      _themeData = darkTheme;
    }
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', themeName);
  }

  static Future<ThemeProvider> loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String themeName = prefs.getString('theme') ?? 'Light';

    ThemeData themeData = (themeName == 'Dark') ? darkTheme : lightTheme;
    return ThemeProvider(themeData, themeName);
  }
}
