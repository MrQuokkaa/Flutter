import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';
import '../exports/page_exports.dart';

void main() async {
  await Hive.initFlutter();

  // ignore: unused_local_variable
  var box = await Hive.openBox('mybox');

  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = await ThemeProvider.loadFromPrefs();

  runApp(
    ChangeNotifierProvider(
      create: (_) => themeProvider,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<bool> _hasUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') != null;
  }

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
            '/nameInput': (context) => NameInputPage(),
            '/settings': (context) => SettingsPage(),
          },
        );
      }
    );
  }
}

class PageDecider extends StatelessWidget {
  const PageDecider({super.key});

  Future<String?> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _loadUserName(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => snapshot.data != null
              ? MainPage(userName: snapshot.data!)
              : NameInputPage(),
            ),
          );
        });

        return const SizedBox.shrink();
      },
    );
  }
}
