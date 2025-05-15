import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';
import '../exports/page_exports.dart';
import '../exports/util_exports.dart';
import '../exports/data_exports.dart';

class HomePage extends StatefulWidget {
  final String userName;
  const HomePage({super.key, required this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DataBase db = DataBase();
  final Functions f = Functions();
  late DayWatcher _dayWatcher;

  @override
  void initState() {
    super.initState();
    _loadTodayTasks();
    _dayWatcher = DayWatcher(onDayChanged: (newDay) {
      db.loadDataForDate(newDay);
      setState(() {});
    });
  }
  
  void _loadTodayTasks() {
    final today = DateTime.now();
    db.loadDataForDate(today);
  }

  @override
  void dispose() {
    _dayWatcher.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            f.appBarText(context),
            Text(
              f.getGreeting(widget.userName),
              style: textTheme.titleMedium,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: Hive.box('mybox').listenable(),
              builder: (context, Box box, _) {
                final today = DateTime.now();
                final todayKey = db.getKeyForDate(today);
                final weekdayKey = db.getWeekdayKey(today.weekday);

                db.loadDataForDate(today);

                List toDoList = List.from(
                  box.get(todayKey) ?? box.get(weekdayKey, defaultValue: []),
                );

                final int uncompletedCount =
                    toDoList.where((task) => task[1] == false).length;

                final Icon leadingIcon = Icon(
                  uncompletedCount > 0
                      ? Icons.pending_actions
                      : Icons.celebration,
                  color: themeColor(context).tertiary,
                );

                final String titleText = uncompletedCount > 0
                    ? "Uncompleted Tasks"
                    : "You've finished all tasks 🎉";

                final Widget? subtitleText = uncompletedCount > 0
                    ? Text(
                        "$uncompletedCount task${uncompletedCount == 1 ? '' : 's'} remaining",
                        style: TextStyle(fontSize: 16),
                      )
                    : null;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ToDoPage(),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: themeColor(context).primary,
                    child: ListTile(
                        leading: leadingIcon,
                        title: Text(
                          titleText,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: subtitleText),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Center(child: Text("Home Page Content Placeholder")),
          ],
        ),
      ),
    );
  }
}
