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

  void loadDataForDate(DateTime date) {
    String key = _getKeyForDate(date);
    toDoList = _myBox.get(key) ?? [];
  }

  void updateDataForDate(DateTime date) {
    String key = _getKeyForDate(date);
    _myBox.put(key, toDoList);
  }

  String _getKeyForDate(DateTime date) {
    return 'TODO_${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
  }

  void loadDataBase() {
    toDoList = _myBox.get('TODOLIST') ?? [];
  }
}
