import '../exports/package_exports.dart';

class FirestoreDataBase {
  List toDoList = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get userId => _auth.currentUser!.uid;

  String getKeyForDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> loadDataForDate(DateTime date) async {
    String key = getKeyForDate(date);
    DocumentSnapshot snapshot = await _firestore
      .collection('users')
      .doc(userId)
      .collection('todos')
      .doc(key)
      .get();

    if (snapshot.exists && snapshot.data() != null && (snapshot.data()! as Map).containsKey('items')) {
      toDoList = List.from(snapshot['items']);
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
  }

  Future <void> updateDataForDate(DateTime date) async {
    String key = getKeyForDate(date);
    await _firestore
      .collection('users')
      .doc(userId)
      .collection('todos')
      .doc(key)
      .set({'items': toDoList});
  }

  Future<void> addTask(String taskName, DateTime date) async {
    toDoList.add([taskName, false]);
    await updateDataForDate(date);
  }

  Future<void> deleteTask(int index, DateTime date) async {
    toDoList.removeAt(index);
    await updateDataForDate(date);
  }

  Future<void> completeTask(int index, DateTime date) async {
    toDoList[index][1] = !toDoList[index][1];
    await updateDataForDate(date);
  }  
}
