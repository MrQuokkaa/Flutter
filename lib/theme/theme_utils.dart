import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';

ThemeData buildCustomTheme({
  required ThemePreset preset,
  required Brightness brightness,
}) {
  
  final primaryScheme = ColorScheme.fromSeed(seedColor: preset.primary, brightness: brightness);
  final secondaryScheme = ColorScheme.fromSeed(seedColor: preset.secondary, brightness: brightness);
  final tertiaryScheme = ColorScheme.fromSeed(seedColor: preset.tertiary, brightness: brightness);

  final scheme = primaryScheme.copyWith(
    secondary: secondaryScheme.primary,
    onSecondary: secondaryScheme.onPrimary,
    tertiary: tertiaryScheme.primary,
    onTertiary: tertiaryScheme.onPrimary,

    background: brightness == Brightness.dark ? const Color(0xFFFFFDFA) : const Color(0xFFFFFDFA),
    onBackground: brightness == Brightness.dark ? Colors.white : Colors.black,
    surface: brightness == Brightness.dark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7),
    onSurface: brightness == Brightness.dark ? Colors.white70 : Colors.black87,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.background,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.background,
      indicatorColor: preset.tertiary.withOpacity(0.2),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return IconThemeData(color: preset.tertiary);
        }
      return IconThemeData(color: Colors.grey);
      }),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        return TextStyle(
          color: states.contains(MaterialState.selected)
            ? preset.tertiary
            : scheme.onSurface.withOpacity(0.6),
        );
      }),
    ),
  );
}

ThemePreset getThemePreset(String name) {
  return presets.firstWhere(
    (p) => p.name == name,
    orElse: () => presets.first,
  );
}

ThemePreset themeColor(BuildContext context) {
  final selectedTheme = Provider.of<ThemeProvider>(context).themeName;
  return presets.firstWhere(
    (preset) => preset.name == selectedTheme,
    orElse: () => presets.first,
    );
}