import 'package:hive_flutter/hive_flutter.dart';

// every day their own database
// store weekday as int -> newDay check int and change if it's a new day

class DataBase {
  List<String> dList = <String>['MondayList', 'TuesdayList', 'WednesdayList', 'ThursdayList', 'FridayList', 'SaturdayList', 'SundayList', 'FreeList', 'toDoList'];
  int Dindex = 0;

  List toDoList = [];
  List tdMonday = [];
  List tdTuesday = [];
  List tdWednesday = [];
  List tdThursday = [];
  List tdFriday = [];
  List tdSaturday = [];
  List tdSunday = [];
  List tdFree = [];


  final _myBox = Hive.box('mybox');

  void createInitialData() {
    toDoList = [
      ["Example Task", false],
      ["Do Exercise", false],
    ];
    tdMonday = [
      ["Work", false],
    ];
    tdTuesday = [
      ["Work", false],
      ["Exercise", false],
    ];
    tdWednesday = [
      ["Work", false],
    ];
    tdThursday = [
      ["Work", false],
      ["Exercise", false],
    ];
    tdFriday = [
      ["Work", false],
    ];
    tdSaturday = [
      ["Exersice", false],
    ];
    tdSunday = [
      ["Meal Prep", false],
    ];
    tdFree = [
      ["Exercise", false],
    ];
  }

  void loadDataBase() {
    toDoList = _myBox.get('TODOLIST');
  }

  void updateDataBase() {
    _myBox.put('TODOLIST', toDoList);
  }
}