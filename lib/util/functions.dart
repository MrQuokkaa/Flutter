import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Functions {
  String dateDay = DateFormat('EEEE').format(DateTime.now());

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  String getGreeting(String name) {
    final hour = DateTime.now().hour;
    String baseGreeting;
    if (hour < 12) {
      baseGreeting = 'Good morning';
    } else if (hour < 17) {
      baseGreeting = 'Good afternoon';
    } else {
      baseGreeting = 'Good evening';
    }
    return '$baseGreeting, $name';
  }

  appBarText() {
    final d = DateTime.now();
    var dayOfMonth = d.day;
    String dateFull = DateFormat('EEEE, MMMM d').format(DateTime.now());
    return dayOfMonth == 1 || dayOfMonth == 21 || dayOfMonth == 31
        ? Text('$dateFull st')
        : dayOfMonth == 2 || dayOfMonth == 22
            ? Text('$dateFull nd')
            : dayOfMonth == 3 || dayOfMonth == 23
                ? Text('$dateFull rd')
                : Text('$dateFull th');
  }

  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);
  }
}
