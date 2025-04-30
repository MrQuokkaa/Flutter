import 'package:flutter/material.dart';
import '../data/database.dart';

class EditWeekdayPage extends StatefulWidget {
  final String weekday;
  const EditWeekdayPage({required this.weekday, super.key});

  @override
  State<EditWeekdayPage> createState() => _EditWeekdayPageState();
}

class _EditWeekdayPageState extends State<EditWeekdayPage> {
  final DataBase db = DataBase();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    db.loadDataForDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.weekday} Tasks"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => setState(() {
              db.updateDataForDate(DateTime.now());
            }),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ReorderableListView(
              buildDefaultDragHandles: false,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = db.toDoList.removeAt(oldIndex);
                  db.toDoList.insert(newIndex, item);
                });
                db.updateDataForDate(DateTime.now());
              },
              children: db.toDoList.asMap().entries.map((entry) {
                int index = entry.key;
                var task = entry.value;
                return Card(
                  key: ValueKey(task[0]),
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        ReorderableDragStartListener(
                          index: index,
                          child:
                              Icon(Icons.drag_handle, color: Colors.grey[700]),
                        ),
                        SizedBox(width: 12),
                        Checkbox(
                          value: task[1],
                          onChanged: (_) => setState(() {
                            db.completeTask(index, DateTime.now());
                          }),
                        ),
                        Expanded(
                          child: Text(
                            task[0],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => db.deleteTask(index, DateTime.now()),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
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
                  onPressed: () => db.addTask(_controller.text, DateTime.now()),
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
