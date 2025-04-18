import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
    if (_myBox.containsKey(key)) {
      toDoList = _myBox.get(key) ?? [];
    } else {
      int weekday = date.weekday;
      String defaultKey = _getWeekdayKey(weekday);
      toDoList = List.from(_myBox.get(defaultKey) ?? []);
    }
  }

  void updateDataForDate(DateTime date) {
    String key = _getKeyForDate(date);
    _myBox.put(key, toDoList);
  }

  void loadDataBase() {
    toDoList = _myBox.get('TODOLIST') ?? [];
  }

  String _getKeyForDate(DateTime date) {
    return 'TODO_${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
  }

  String _getWeekdayKey(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'MONDAY_TODO';
      case DateTime.tuesday:
        return 'TUESDAY_TODO';
      case DateTime.wednesday:
        return 'WEDNESDAY_TODO';
      case DateTime.thursday:
        return 'THURSDAY_TODO';
      case DateTime.friday:
        return 'FRIDAY_TODO';
      case DateTime.saturday:
        return 'SATURDAY_TODO';
      case DateTime.sunday:
        return 'SUNDAY_TODO';
      default:
        return 'MONDAY_TODO';
    }
  }
}
