import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:daily/pages/home_page.dart';

void main() async {
  
  await Hive.initFlutter();
  
  // ignore: unused_local_variable
  var box = await Hive.openBox('mybox');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.lightBlue),
      ),
    );
  }
}
