import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';
import '../exports/util_exports.dart';

class DayWatcher {
  final void Function(DateTime newLogicalDay) onDayChanged;
  Timer? _timer;
  late DateTime _lastLogicalDay;

  DayWatcher({required this.onDayChanged}) {
    _lastLogicalDay = _getLogicalDate(DateTime.now());
    _startListening();
  }

  DateTime _getLogicalDate(DateTime now) {
    return now.hour < 3
        ? DateTime(now.year, now.month, now.day - 1)
        : DateTime(now.year, now.month, now.day);
  }

  void _startListening() {
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      final currentLogicalDay = _getLogicalDate(DateTime.now());
      if (!_isSameDay(currentLogicalDay, _lastLogicalDay)) {
        _lastLogicalDay = currentLogicalDay;
        onDayChanged(currentLogicalDay);
      }
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void dispose() {
    _timer?.cancel();
  }
}