import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/database.dart';
import '../util/todo_tile.dart';
import '../util/dialog_box.dart';
import '../util/functions.dart';

//import intl.dart for date + day
// Day of week to int -> use int for databases

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoState();
}

class _ToDoState extends State<ToDoPage> {
  final _myBox = Hive.box('mybox');
  DataBase db = DataBase();
  Functions f = Functions();
  DateTime selectedDate = DateTime.now();
  final _controller = TextEditingController();

  @override
  void initState() {
    if (_myBox.get('MONDAY_TODO') == null) {
      db.createInitialData();
    }
    db.loadDataForDate(selectedDate);
    super.initState();
  }

  String getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final selected = DateTime(date.year, date.month, date.day);

    if (selected == today) {
      return "Today";
    } else if (selected == tomorrow) {
      return "Tomorrow";
    } else {
      return DateFormat('EEEE, d MMM').format(date);
    }
  }

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        db.loadDataForDate(selectedDate);
      });
    }
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataForDate(selectedDate);
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataForDate(selectedDate);
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataForDate(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[200],
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          Center(
            child: GestureDetector(
              onTap: _pickDate,
              child: Text(
                "~ Tasks for ${getFormattedDate(selectedDate)} ~",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: db.toDoList.length,
              itemBuilder: (context, index) {
                return ToDoTile(
                  taskName: db.toDoList[index][0],
                  taskCompleted: db.toDoList[index][1],
                  onChanged: (value) => checkBoxChanged(value, index),
                  deleteFunction: (context) => deleteTask(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
