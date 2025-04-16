import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../pages/settings_page.dart';
import '../pages/profile_page.dart';
import '../pages/home_page.dart';
import '../pages/todo_page.dart';
import '../util/functions.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> pages = [
    const HomePage(),
    const ToDoPage(),
    const ProfilePage(),
    const SettingsPage(),
  ];

  Functions f = Functions();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (value) {
          f.checkDay();
          setState(() {
            currentPage = value;
          });
        },
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.lightBlue,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: "To Do",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
