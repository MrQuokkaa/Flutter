import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';
import '../exports/page_exports.dart';
import '../exports/util_exports.dart';

class Functions {
  String dateDay = DateFormat('EEEE').format(DateTime.now());

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

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
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed');
    }
  }

  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);
  }

  Future<User?> register(String name, String email, String password) async {
    debugLog('[Register] User is being registered..');
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.updateDisplayName(name);
      print('[Register] User succesfully registered, redirecting..');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? '[Register] User registration failed');
    }
  }

  Future<void> logout(BuildContext context) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    await themeProvider.applyFallbackTheme();

    HomePage.resetCard();

    await FirebaseAuth.instance.signOut();
    debugLog('[Logout] User logged out, redirecting..');

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }
}
