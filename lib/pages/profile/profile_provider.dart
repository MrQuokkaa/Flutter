import '../../exports/package_exports.dart';

class ProfileProvider with ChangeNotifier {
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> loadProfileImage() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data()!.containsKey('profileImageUrl')) {
      _imageUrl = doc['profileImageUrl'];
      notifyListeners();
    }
  }

  void updateProfileImage(String url) {
    _imageUrl = url;
    notifyListeners();
  }
}