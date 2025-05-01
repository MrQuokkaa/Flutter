import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';
import '../exports/page_exports.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool showWeekdayOptions = false;

  final List<String> weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  String selectedTheme = 'Light';

  @override
  void initState() {
    super.initState();
    selectedTheme = Provider.of<ThemeProvider>(context, listen: false).themeName;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        children: [
          ListTile(
            title: Text("Change default tasks"),
            trailing: Icon(
              showWeekdayOptions ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () {
              setState(() {
                showWeekdayOptions = !showWeekdayOptions;
              });
            },
          ),
          if (showWeekdayOptions) ...weekdays.map((day) => ListTile(
            title: Text("Tasks for $day"),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DefaultTodoPage(weekday: day),
                ),
               );
            },
          )),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("App Theme", style: TextStyle(fontSize: 16)),
                DropdownButton<String>(
                  value: selectedTheme,
                  items: getSortedThemeItems(selectedTheme, themeList),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => selectedTheme = value);
                    themeProvider.setTheme(value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 250)
        ],
      ),
    );
  }
}
