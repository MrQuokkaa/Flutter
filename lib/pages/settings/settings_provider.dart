import '../../exports/package_exports.dart';

class SettingsProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _dayStartHour = '00:00';
  String get dayStartHour => _dayStartHour;

  Future<void> loadSettings() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('settings')
        .doc('dayStart');

    final doc = await docRef.get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      _dayStartHour = data['hour'] ?? '00:00';
    } else {
      await docRef.set({'hour': '00:00'});
      _dayStartHour = '00:00';
    }

    notifyListeners();
  }

  Future<void> setDayStartHour(String hour) async {
    final user = _auth.currentUser;
    if (user == null) return;

    _dayStartHour = hour;
    notifyListeners();

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('settings')
        .doc('dayStart');

    await docRef.set({'hour': hour});
  }
}
