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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Functions f = Functions();
  late DayWatcher _dayWatcher;

  List<List<dynamic>> todayTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTodayTasks();
    _dayWatcher = DayWatcher(onDayChanged: (newDay) {
      _loadTasksForDate(newDay);
    });
  }

  @override
  void dispose() {
    _dayWatcher.dispose();
    super.dispose();
  }

  Future<void> _loadTodayTasks() async {
    final now = DateTime.now();
    await _loadTasksForDate(now);
  }

  Future<void> _loadTasksForDate(DateTime date) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    String _getWeekdayString(int weekday) {
      const weekdays = [
        "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
      ];
      return weekdays[weekday - 1];
    }

    final todayKey = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final weekday = _getWeekdayString(date.weekday);

    DocumentSnapshot<Map<String, dynamic>> dailyDoc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('dailyTodos')
        .doc(todayKey)
        .get();

    if (dailyDoc.exists) {
      final tasks = dailyDoc.data()?['tasks'];
      if (tasks is List) {
        setState(() {
          todayTasks = List<List<dynamic>>.from(
            tasks.map((t) => [t['name'], t['completed']]),
          );
        });
        return;
      }
    }

    final defaultDoc = await _firestore
      .collection('users')
      .doc(uid)
      .collection('defaultTodos')
      .doc(weekday)
      .get();

    if (dailyDoc.exists) {
      final tasks = dailyDoc.data()?['tasks'];
      if (tasks is List) {
        setState(() {
          todayTasks = List<List<dynamic>>.from(
            tasks.map((t) => [t['name'], t['completed']]),
          );
        });
      } else {
        setState(() {
          todayTasks = [];
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final int uncompletedCount = todayTasks.where((task) => task[1] == false).length;

    final Icon leadingIcon = Icon(
      uncompletedCount > 0 ? Icons.pending_actions : Icons.celebration,
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ToDoPage()),
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
                  subtitle: subtitleText,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(child: Text("Home Page Content Placeholder")),
          ],
        ),
      ),
    );
  }
}
