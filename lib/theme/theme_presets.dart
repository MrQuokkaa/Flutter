import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';

//pink #FFB7C5, red #FF9999, orange #FFD1A6, yellow #FFEE99, green #B2E5B2, turqoise #B2F5E5, blue #C6E2FF, dark blue #A6B8FF, purple #D1B3FF

class ThemePreset {
  final String name;
  final Color primary;
  final Color secondary;
  final Color tertiary;

  ThemePreset({
    required this.name,
    required this.primary,
    required this.secondary,
    required this.tertiary,
  });
}

final List<ThemePreset> presets = [
  ThemePreset(
    name: 'Pink',
    primary: Color(0xFFFFB7C5),
    secondary: Color(0xFFFF9999),
    tertiary: Color(0xFFFFD1A6)),
  ThemePreset(
    name: 'Red',
    primary: Color(0xFFFF9999),
    secondary: Color(0xFFFFB7C5),
    tertiary: Color(0xFFFFD1A6)),
  ThemePreset(
    name: 'Orange',
    primary: Color(0xFFFFD1A6),
    secondary: Color(0xFFFF9999),
    tertiary: Color(0xFFFFEE99)),
  ThemePreset(
    name: 'Yellow',
    primary: Color(0xFFFFEE99),
    secondary: Color(0xFFFFD1A6),
    tertiary: Color(0xFFB2E5B2)),
  ThemePreset(
    name: 'Green',
    primary: Color(0xFFB2E5B2),
    secondary: Color(0xFFB2F5E5),
    tertiary: Color(0xFFB2E5B2)),
  ThemePreset(
    name: 'Turquoise',
    primary: Color(0xFFB2F5E5),
    secondary: Color(0xFFB2E5B2),
    tertiary: Color(0xFFC6E2FF)),
  ThemePreset(
    name: 'Blue',
    primary: Color(0xFFC6E2FF),
    secondary: Color(0xFFA6B8FF),
    tertiary: Color(0xFFD1B3FF)),
  ThemePreset(
    name: 'Dark Blue',
    primary: Color(0xFFA6B8FF),
    secondary: Color(0xFFC6E2FF),
    tertiary: Color(0xFFD1B3FF)),
  ThemePreset(
    name: 'Purple',
    primary: Color(0xFFD1B3FF),
    secondary: Color(0xFFA6B8FF),
    tertiary: Color(0xFFB2F5E5)),
];
