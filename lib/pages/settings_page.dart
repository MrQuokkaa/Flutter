import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';
import '../exports/page_exports.dart';
import '../exports/util_exports.dart';

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

  List<String> hours =
      List.generate(24, (i) => i.toString().padLeft(2, '0') + ":00");
  String selectedHour = '00:00';

  @override
  void initState() {
    super.initState();
    selectedTheme =
        Provider.of<ThemeProvider>(context, listen: false).themeName;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final textTheme = Theme.of(context).textTheme;

    final sortedPresets = presets.toList()
      ..sort((a, b) => a.name == selectedTheme
          ? -1
          : b.name == selectedTheme
              ? 1
              : 0);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Settings",
          style: textTheme.headlineLarge,
        ),
        actions: [
          if (debugMode)
            IconButton(
              icon: const Icon(Icons.bug_report),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DebugPage()),
                );
              },
            ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                      onChanged: (value) async {
                        if (value == null || value == 'Select day') return;
                        setState(() => selectedDay = value);

                        final uid = FirebaseAuth.instance.currentUser?.uid;
                        if (uid == null) return;

                        final doc = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('defaultTodos')
                            .doc(value)
                            .get();

                        List<List<dynamic>> tasks = [];
                        if (doc.exists) {
                          final data = doc.data();
                          if (data != null && data['tasks'] is List) {
                            tasks = List<List<dynamic>>.from(
                              data['tasks'].map(
                                  (task) => [task['name'], task['completed']]),
                            );
                          }
                        }

                        await Future.delayed(Duration(milliseconds: 50));

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DefaultTodoPage(
                                weekday: value, toDoList: tasks),
                          ),
                        ).then((_) {
                          setState(() => selectedDay = 'Select day');
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                  onChanged: (value) async {
                    debugLog('[Settings] Dropdown changed to: $value');
                    if (value == null) return;
                    setState(() => selectedTheme = value);

                    final brightness = themeProvider.brightness;
                    await themeProvider.setTheme(value, brightness: brightness);
                    debugLog('[Settings] Theme updated and saved for user');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
