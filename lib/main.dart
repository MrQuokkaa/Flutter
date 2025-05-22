import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';
import '../exports/page_exports.dart';

void main() async {
  // ignore: unused_local_variable

  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = await ThemeProvider.loadTheme();
  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => settingsProvider),
      ],
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
          final user = snapshot.data!;
          final name = user.displayName ?? user.email ?? 'User';
          return MainPage(userName: name);
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
