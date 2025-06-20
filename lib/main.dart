import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';
import '../exports/data_exports.dart';
import '../exports/page_exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  final user = FirebaseAuth.instance.currentUser;

  final themeProvider = user != null
      ? await ThemeProvider.loadTheme()
      : await _loadFallbackTheme();

  runApp(MyApp(
    settingsProvider: settingsProvider,
    themeProvider: themeProvider,
    user: user,
  ));
}

Future<ThemeProvider> _loadFallbackTheme() async {
  final fallbackPreset = getThemePreset('Purple');
  final fallbackTheme = buildCustomTheme(
    preset: fallbackPreset,
    brightness: Brightness.light,
  );
  return ThemeProvider(fallbackTheme, 'Purple', Brightness.light);
}

class MyApp extends StatelessWidget {
  final SettingsProvider settingsProvider;
  final ThemeProvider themeProvider;
  final User? user;

  const MyApp({
    super.key,
    required this.settingsProvider,
    required this.themeProvider,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => settingsProvider),
        ChangeNotifierProvider(create: (_) => FirestoreDataBase()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme.themeData,
            initialRoute: '/',
            routes: {
              '/': (context) =>
                  user != null ? const MainPageLauncher() : const LoginPage(),
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/settings': (context) => const SettingsPage(),
            },
          );
        },
      ),
    );
  }
}

class MainPageLauncher extends StatelessWidget {
  const MainPageLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return MainPage();
  }
}
