import '../../exports/package_exports.dart';
import '../../exports/data_exports.dart';

class DefaultTodoPage extends StatefulWidget {
  final String weekday;
  const DefaultTodoPage({required this.weekday, super.key});

  @override
  State<DefaultTodoPage> createState() => _DefaultTodoPageState();
}

class _DefaultTodoPageState extends State<DefaultTodoPage> {
  final DataBase db = DataBase();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    db.loadDefaultDay(widget.weekday);
  }

  void _save() {
    db.updateDefaultDay(widget.weekday);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.weekday}"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              setState(_save);
            },
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
                _save();
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
                          onChanged: (_) {
                            setState(() {
                              db.toDoList[index][1] = !db.toDoList[index][1];
                              _save();
                            });
                          },
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
                          onPressed: () {
                            setState(() {
                              db.toDoList.removeAt(index);
                              _save();
                            });
                          },
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
                  onPressed: () {
                    setState (() {
                      db.toDoList.add([_controller.text, false]);
                      _controller.clear();
                      _save();
                    });
                  },
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