import '../exports/package_exports.dart';

class FirestoreDataBase with ChangeNotifier{
  List<List<dynamic>> toDoList = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestoreDataBase();

  String get userId => _auth.currentUser!.uid;

  String getKeyForDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  List<List<dynamic>> get toDoListCopy =>
    List.from(toDoList.map((e) => [...e]));

  Future<void> loadDataForDate(DateTime date) async {
    String key = getKeyForDate(date);
    DocumentSnapshot snapshot = await _firestore
      .collection('users')
      .doc(userId)
      .collection('todos')
      .doc(key)
      .get();

    if (snapshot.exists && snapshot.data() != null && (snapshot.data()! as Map).containsKey('items')) {
      toDoList = (snapshot['items'] as List).map((item) => [item['name'], item['completed']]).toList();
    } else {
      String weekday = DateFormat('EEEE').format(date);
      DocumentSnapshot defaultSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('defaultTodos')
        .doc(weekday)
        .get();

      if (defaultSnapshot.exists && 
       defaultSnapshot.data() != null &&
       (defaultSnapshot.data()! as Map).containsKey('tasks')) {
          toDoList = List<List<dynamic>>.from(
            (defaultSnapshot['tasks'] as List).map(
              (task) => [task['name'], task['completed']],
            ),
          );
      } else {
        toDoList = [];
      }
    }

    notifyListeners();
  }

  Future <void> updateDataForDate(DateTime date) async {
    String key = getKeyForDate(date);

    List<Map<String, dynamic>> mappedList = toDoList.map((item) => {
      'name': item[0],
      'completed': item[1],
    }).toList();

    await _firestore
      .collection('users')
      .doc(userId)
      .collection('todos')
      .doc(key)
      .set({'items': mappedList});
    notifyListeners();
  }

  Future<void> addTask(String taskName, DateTime date) async {
    toDoList.add([taskName, false]);
    toDoList = List.from(toDoList);
    await updateDataForDate(date);
    notifyListeners();
  }

  Future<void> deleteTask(int index, DateTime date) async {
    toDoList.removeAt(index);
    toDoList = List.from(toDoList);
    await updateDataForDate(date);
    notifyListeners();
  }

  Future<void> completeTask(int index, DateTime date) async {
    toDoList[index][1] = !toDoList[index][1];
    toDoList = List.from(toDoList);
    await updateDataForDate(date);
    notifyListeners();
  }  
}
