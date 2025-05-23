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
  final Functions f = Functions();
  late DayWatcher _dayWatcher;

  int taskCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    
    _loadTodayTaskCount();

    _dayWatcher = DayWatcher(onDayChanged: (newDay) {
      _loadTaskCountForDate(newDay);
    });
  }

  @override
  void dispose() {
    _dayWatcher.dispose();
    super.dispose();
  }

  Future<void> _loadTodayTaskCount() async {
    await _loadTaskCountForDate(DateTime.now());
  }

  Future<void> _loadTaskCountForDate(DateTime date) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('todos')
      .doc(key)
      .get();

    if (!mounted) return;

    if (doc.exists && doc.data()?['items'] != null) {
      final items = doc.data()!['items'] as List;
      setState (() {
        taskCount = items.length;
        isLoading = false;
      });
    } else {
      setState(() {
        taskCount = 0;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final int uncompletedCount = taskCount;
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
                _loadTodayTaskCount();
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
