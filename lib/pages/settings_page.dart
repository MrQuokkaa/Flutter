import 'package:flutter/material.dart';
import '../pages/edit_weekday_page.dart';

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

  @override
  Widget build(BuildContext context) {
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
          if (showWeekdayOptions)
            ...weekdays.map((day) => ListTile(
                  title: Text("Tasks for $day"),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditWeekdayPage(weekday: day),
                      ),
                    );
                  },
                )),
        ],
      ),
    );
  }
}
