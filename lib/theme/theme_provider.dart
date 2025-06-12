import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';
import '../exports/util_exports.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeData _themeData;
  late String _themeName;
  late Brightness _brightness;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ThemeProvider(this._themeData, this._themeName, this._brightness) {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        await loadFromFirestore();
      } else {
        final fallbackPreset = getThemePreset('Purple');
        final fallbackTheme = buildCustomTheme(
            preset: fallbackPreset, brightness: Brightness.light);
        _themeData = fallbackTheme;
        _themeName = 'Purple';
        _brightness = Brightness.light;
        notifyListeners();
      }
    });
  }

  ThemeData get themeData => _themeData;
  String get themeName => _themeName;
  Brightness get brightness => _brightness;

  Future<void> setTheme(String themeName, {Brightness? brightness}) async {
    debugLog('[ThemeProvider] setTheme called with: $themeName');
    final user = _auth.currentUser;
    debugLog('[ThemeProvider] Current user: ${user?.email}');

    _themeName = themeName;
    _brightness = brightness ?? _brightness;

    final preset = getThemePreset(themeName);
    _themeData = buildCustomTheme(preset: preset, brightness: _brightness);

    notifyListeners();
    debugLog('[ThemeProvider] Theme updated locally and listeners notified');

    final uid = user?.uid;
    if (uid != null) {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('settings')
          .doc('theme')
          .set({
        'themeName': _themeName,
        'brightness': _brightness.name,
      });
      debugLog('[ThemeProvider] Theme saved to Firestore for UID: $uid');
    } else {
      debugLog('[ThemeProvider] No user is logged in');
    }
  }

  static Future<ThemeProvider> loadTheme() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final uid = auth.currentUser?.uid;

    final fallbackTheme = 'Purple';
    final fallbackBrightness = Brightness.light;
    final fallbackPreset = getThemePreset(fallbackTheme);
    final fallbackData = buildCustomTheme(
        preset: fallbackPreset, brightness: fallbackBrightness);

    if (uid != null) {
      final docRef = await firestore
          .collection('users')
          .doc(uid)
          .collection('settings')
          .doc('theme');

      final doc = await docRef.get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final themeName = data['themeName'] ?? fallbackTheme;
        final brightnessString = data['brightness'] ?? 'light';
        final brightness =
            brightnessString == 'dark' ? Brightness.dark : Brightness.light;

        final preset = getThemePreset(themeName);
        final themeData =
            buildCustomTheme(preset: preset, brightness: brightness);

        return ThemeProvider(themeData, themeName, brightness);
      } else {
        await docRef.set({
          'themeName': fallbackTheme,
          'brightness': fallbackBrightness.name,
        });
        debugLog(
            '[ThemeProvider] No theme settings found. Saving fallback theme to Firestore');
      }
    }

    return ThemeProvider(fallbackData, fallbackTheme, fallbackBrightness);
  }

  Future<void> loadFromFirestore() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('settings')
        .doc('theme');

    final doc = await docRef.get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      final themeName = data['themeName'] ?? _themeName;
      final brightnessString = data['brightness'] ?? _brightness.name;
      final brightness =
          brightnessString == 'dark' ? Brightness.dark : Brightness.light;

      final preset = getThemePreset(themeName);
      _themeData = buildCustomTheme(preset: preset, brightness: brightness);
      _themeName = themeName;
      _brightness = brightness;
      notifyListeners();
    }
  }

  Future<void> applyFallbackTheme() async {
    final fallbackPreset = getThemePreset('Purple');
    _themeData =
        buildCustomTheme(preset: fallbackPreset, brightness: Brightness.light);
    _themeName = 'Purple';
    _brightness = Brightness.light;
    notifyListeners();

    debugLog('[Logout] Applied fallback theme');
    await WidgetsBinding.instance.endOfFrame;
  }
}
