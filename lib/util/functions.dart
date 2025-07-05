import 'package:intl/intl.dart';
import '../exports/package_exports.dart';
import '../exports/page_exports.dart';
import '../exports/util_exports.dart';

class Functions {
  String dateDay = DateFormat('EEEE').format(DateTime.now());

  String getGreeting(String name) {
    final hour = DateTime.now().hour;
    String baseGreeting;
    if (hour < 12) {
      baseGreeting = 'Good morning';
    } else if (hour < 17) {
      baseGreeting = 'Good afternoon';
    } else {
      baseGreeting = 'Good evening';
    }
    return '$baseGreeting, $name';
  }

  appBarText(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final d = DateTime.now();
    var dayOfMonth = d.day;
    String dateFull = DateFormat('EEEE, MMMM d').format(DateTime.now());
    final suffix = (dayOfMonth == 1 || dayOfMonth == 21 || dayOfMonth == 31)
        ? 'st'
        : (dayOfMonth == 2 || dayOfMonth == 22)
            ? 'nd'
            : (dayOfMonth == 3 || dayOfMonth == 23)
                ? 'rd'
                : 'th';
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        '$dateFull$suffix',
        style: textTheme.headlineLarge,
      ),
    );
  }

  Future<User?> login(String email, String password) async {
    debugLog('[Login] Attempting login..');
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user != null) {
        final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
        final docSnapshot = await userDocRef.get();

        if (!docSnapshot.exists) {
          await userDocRef.set({
            'displayName': user.displayName ?? 'User',
            'profileImageUrl': '',
            'level': 0,
            'xp': 0,
            'createdAt': FieldValue.serverTimestamp(),
          });
          debugLog('[Login] Created user document for ${user.uid}');
        }
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed');
    }
  }

  Future<User?> register(String name, String email, String password) async {
    debugLog('[Register] User is being registered..');
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('[Register] User creation failed');

      await user.updateDisplayName(name);

      final firestore = FirebaseFirestore.instance;
      await firestore.collection('users').doc(user.uid).set({
        'displayName': name,
        'profileImageUrl': '',
        'level': 0,
        'xp': 0,
        'createAt': FieldValue.serverTimestamp(),
      });

      debugLog('[Register] User succesfully registered..');
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? '[Register] User registration failed');
    }
  }

  Future<void> logout(BuildContext context) async {
    HomePage.resetCard();

    if (context.mounted) {
      await FirebaseAuth.instance.signOut();
      debugLog('[Logout] User logged out, redirecting..');
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }
}
