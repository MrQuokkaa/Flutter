import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';
import '../exports/page_exports.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<String> weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  String selectedTheme = 'Blue';
  String? selectedDay = 'Select day';

  @override
  void initState() {
    super.initState();
    selectedTheme =
        Provider.of<ThemeProvider>(context, listen: false).themeName;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final sortedPresets = presets.toList()
      ..sort((a, b) => a.name == selectedTheme
          ? -1
          : b.name == selectedTheme
              ? 1
              : 0);

    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Change default tasks",
                    style: TextStyle(fontSize: 16)),
                DropdownButton<String>(
                  value: selectedDay,
                  items: ['Select day', ...weekdays].map((day) {
                    return DropdownMenuItem<String>(
                      value: day,
                      child: Text(day),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null || value == 'Select day') return;
                    setState(() {
                      selectedDay = value;
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DefaultTodoPage(weekday: value),
                      ),
                    ).then((_) {
                      setState(() {
                        selectedDay = 'Select day';
                      });
                    });
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("App Theme", style: TextStyle(fontSize: 16)),
                DropdownButton<String>(
                  value: sortedPresets.any((p) => p.name == selectedTheme)
                      ? selectedTheme
                      : sortedPresets.first.name,
                  items: sortedPresets.map((preset) {
                    return DropdownMenuItem<String>(
                      value: preset.name,
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: preset.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black12),
                            ),
                          ),
                          Text(preset.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => selectedTheme = value);

                    final brightness = themeProvider.brightness;
                    themeProvider.setTheme(value);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                  height: 50,
                  color: themeColor(context).primary,
                  child: Center(child: Text('Current Primary Color')))),
          const Divider(),
          Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                  height: 50,
                  color: themeColor(context).secondary,
                  child: Center(child: Text('Current Secondary Color')))),
          const Divider(),
          Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                  height: 50,
                  color: themeColor(context).tertiary,
                  child: Center(child: Text('Current Tertiary Color'))))
        ],
      ),
    );
  }
}
