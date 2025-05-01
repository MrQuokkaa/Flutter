import '../exports/package_exports.dart';

final themeList = ['Light', 'Dark', 'Blue', 'Pink']; 

List<DropdownMenuItem<String>> getSortedThemeItems(String selectedTheme, List<String> allThemes) {
  final sortedThemes = List<String>.from(allThemes);
  sortedThemes.sort((a, b) {
    if (a == selectedTheme) return -1;
    if (b == selectedTheme) return 1;
    return 0;
  });

  return sortedThemes.map((theme) {
    return DropdownMenuItem<String>(
      value: theme,
      child: Text(theme),
    );
  }).toList();
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.deepPurple,
);
