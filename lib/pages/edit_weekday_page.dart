import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EditWeekdayPage extends StatefulWidget {
  final String weekday;
  const EditWeekdayPage({required this.weekday, super.key});

  @override
  State<EditWeekdayPage> createState() => _EditWeekdayPageState();
}

class _EditWeekdayPageState extends State<EditWeekdayPage> {
  final _box = Hive.box('mybox');
  List<List<dynamic>> tasks = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final key = "${widget.weekday.toUpperCase()}_TODO";
    tasks = List<List<dynamic>>.from(_box.get(key, defaultValue: []));
  }

  void saveTasks() {
    final key = "${widget.weekday.toUpperCase()}_TODO";
    _box.put(key, tasks);
    Navigator.pop(context);
  }

  void addTask() {
    setState(() {
      tasks.add([_controller.text, false]);
      _controller.clear();
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void toggleComplete(int index) {
    setState(() {
      tasks[index][1] = !tasks[index][1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.weekday} Tasks"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveTasks,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index][0]),
                  leading: Checkbox(
                    value: tasks[index][1],
                    onChanged: (_) => toggleComplete(index),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteTask(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: "New Task",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: addTask,
                  child: Text("Add"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
