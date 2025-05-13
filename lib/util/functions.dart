import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';

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
        style: themeText(context).headlineLarge,
      ),
    );
  }

  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);
  }
}
