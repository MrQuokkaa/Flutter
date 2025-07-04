import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';

ThemeData buildCustomTheme({
  required ThemePreset preset,
  required Brightness brightness,
}) {
  final primaryScheme =
      ColorScheme.fromSeed(seedColor: preset.primary, brightness: brightness);
  final secondaryScheme =
      ColorScheme.fromSeed(seedColor: preset.secondary, brightness: brightness);
  final tertiaryScheme =
      ColorScheme.fromSeed(seedColor: preset.tertiary, brightness: brightness);

  final scheme = primaryScheme.copyWith(
    secondary: secondaryScheme.primary,
    onSecondary: secondaryScheme.onPrimary,
    tertiary: tertiaryScheme.primary,
    onTertiary: tertiaryScheme.onPrimary,
    surface: brightness == Brightness.dark
        ? const Color(0xFFFFFDFA)
        : const Color(0xFFFFFDFA),
    onSurface: brightness == Brightness.dark ? Colors.white : Colors.black,
  );

  final textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Roboto Slab',
      fontSize: 24,
      fontWeight: FontWeight.w300,
      color: scheme.onSurface,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18,
      fontWeight: FontWeight.w300,
      color: scheme.onSurface,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      color: scheme.onSurface,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      color: scheme.onSurface.withOpacity(0.6),
    ),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surface,
      indicatorColor: preset.tertiary.withOpacity(0.2),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: preset.tertiary);
        }
        return IconThemeData(color: Colors.grey);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        return TextStyle(
          color: states.contains(WidgetState.selected)
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
  final selectedTheme = Provider.of<UserProvider>(context).themeName;
  return presets.firstWhere(
    (preset) => preset.name == selectedTheme,
    orElse: () => presets.first,
  );
}

TextTheme themeText(BuildContext context) {
  return Theme.of(context).textTheme;
}