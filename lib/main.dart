import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../theme/theme_provider.dart';
import '../theme/app_themes.dart';
import '../pages/main_page.dart';

void main() async {
  await Hive.initFlutter();

  // ignore: unused_local_variable
  var box = await Hive.openBox('mybox');

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(lightTheme),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
        theme: themeProvider.themeData,
        home: MainPage(),
        debugShowCheckedModeBanner: false);
  }
}
