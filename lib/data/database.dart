import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// every day their own database
// store weekday as int -> newDay check int and change if it's a new day

class DataBase {
  List toDoList = [];

  final _myBox = Hive.box('mybox');

  Map<int, String> weekdayKeys = {
    DateTime.monday: 'MONDAY_TODO',
    DateTime.tuesday: 'TUESDAY_TODO',
    DateTime.wednesday: 'WEDNESDAY_TODO',
    DateTime.thursday: 'THURSDAY_TODO',
    DateTime.friday: 'FRIDAY_TODO',
    DateTime.saturday: 'SATURDAY_TODO',
    DateTime.sunday: 'SUNDAY_TODO',
  };

  void createInitialData() {
    _myBox.put('MONDAY_TODO', [
      ["Monday", false],
      ["Work", false]
    ]);
    _myBox.put('TUESDAY_TODO', [
      ["Tuesday", false],
      ["Work", false],
      ["Exercise", false]
    ]);
    _myBox.put('WEDNESDAY_TODO', [
      ["Wednesday", false],
      ["Work", false]
    ]);
    _myBox.put('THURSDAY_TODO', [
      ["Thursday", false],
      ["Work", false],
      ["Exercise", false]
    ]);
    _myBox.put('FRIDAY_TODO', [
      ["Friday", false],
      ["Work", false]
    ]);
    _myBox.put('SATURDAY_TODO', [
      ["Saturday", false],
      ["Exercise", false]
    ]);
    _myBox.put('SUNDAY_TODO', [
      ["Sunday", false],
      ["Meal Prep", false]
    ]);
  }

  void loadDataForToday() {
    int today = DateTime.now().weekday;
    String key = weekdayKeys[today]!;
    toDoList = _myBox.get(key) ?? [];
  }

  void updateDataForToday() {
    int today = DateTime.now().weekday;
    String key = weekdayKeys[today]!;
    _myBox.put(key, toDoList);
  }

  void loadDataBase() {
    toDoList = _myBox.get('TODOLIST') ?? [];
  }
}
