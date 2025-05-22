import '../../exports/package_exports.dart';
import '../../exports/theme_exports.dart';
import '../../exports/data_exports.dart';

class DefaultTodoPage extends StatefulWidget {
  final String weekday;
  const DefaultTodoPage({required this.weekday, super.key});

  @override
  State<DefaultTodoPage> createState() => _DefaultTodoPageState();
}

class _DefaultTodoPageState extends State<DefaultTodoPage> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<List<dynamic>> toDoList = [];

  @override
  void initState() {
    super.initState();
    _loadDefaultDay();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadDefaultDay() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final doc = await _firestore
      .collection('users')
      .doc(uid)
      .collection('defaultTodos')
      .doc(widget.weekday)
      .get();

    if (doc.exists) {
      final data = doc.data();
      if (data != null && data['tasks'] is List) {
        setState(() {
          toDoList = List<List<dynamic>>.from(
            data['tasks'].map((task) => [task['name'], task['completed']]),
          );
        });
      }
    }
  }

  Future<void> _save() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final tasks = toDoList.map((task) => {
      'name': task[0],
      'completed': task[1],
    }).toList();

    await _firestore
      .collection('users')
      .doc(uid)
      .collection('defaultTodos')
      .doc(widget.weekday)
      .set({'tasks': tasks});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.weekday}"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              await _save();
              if (mounted) setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ReorderableListView(
              buildDefaultDragHandles: false,
              onReorder: (oldIndex, newIndex) async {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = toDoList.removeAt(oldIndex);
                  toDoList.insert(newIndex, item);
                });
                await _save();
                if (mounted) setState (() {});
              },
              children: toDoList.asMap().entries.map((entry) {
                int index = entry.key;
                var task = entry.value;
                return Card(
                  key: ValueKey(task[0]),
                  elevation: 2,
                  color: themeColor(context).primary,
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
                              Icon(Icons.drag_handle, color: themeColor(context).tertiary),
                        ),
                        SizedBox(width: 12),
                        Checkbox(
                          activeColor: themeColor(context).tertiary,
                          value: task[1],
                          onChanged: (_) async {
                            setState(() {
                              toDoList[index][1] = !toDoList[index][1];
                            });
                            await _save();
                            if (mounted) setState (() {});;
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
                          onPressed: () async {
                            setState(() {
                              toDoList.removeAt(index);
                            });
                            await _save();
                            if (mounted) setState (() {});
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor(context).primary,
                  ),
                  onPressed: () async {
                    if (_controller.text.trim().isEmpty) return;
                    setState (() {
                      toDoList.add([_controller.text.trim(), false]);
                      _controller.clear();
                    });
                    await _save();
                    if (mounted) setState (() {});
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