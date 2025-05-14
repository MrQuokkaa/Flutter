import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';
import '../exports/page_exports.dart';

void main() async {
  await Hive.initFlutter();

  // ignore: unused_local_variable
  var box = await Hive.openBox('mybox');

  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = await ThemeProvider.loadFromPrefs();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (_) => themeProvider,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          initialRoute: '/',
          routes: {
            '/': (context) => const PageDecider(),
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/settings': (context) => const SettingsPage(),
          },
        );
      }
    );
  }
}

class PageDecider extends StatelessWidget {
  const PageDecider({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return MainPage(userName: snapshot.data!.email ?? 'User');
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
