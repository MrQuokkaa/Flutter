import 'package:hive_flutter/hive_flutter.dart';
import 'package:daily/data/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../util/todo_tile.dart';
import '../util/dialog_box.dart';
import '../util/functions.dart';


//import intl.dart for date + day
// Day of week to int -> use int for databases

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  DataBase db = DataBase();
  Functions f = Functions();

  @override
  void initState() {
    if (_myBox.get('TODOLIST') == null) {
      db.createInitialData();
    } else {
      db.loadDataBase();
    }
    super.initState();
  }

  final _controller = TextEditingController();
  
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index] [1] = !db.toDoList[index] [1];
    });
    db.updateDataBase();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
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
    db.updateDataBase();
  }

  String dateFull = DateFormat('EEEE, MMMM d').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    f.checkDay();
    int today = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (today != f.checkDay()) {
        today = f.checkDay();
        f.OpenDialog(context);
      }
    });
    
    return Scaffold(
      backgroundColor: Colors.lightBlue[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text(dateFull + 'th'), //date + day -> Monday - July 15
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder:(context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0], 
            taskCompleted: db.toDoList[index][1], 
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}

