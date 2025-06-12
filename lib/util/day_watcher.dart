import '../exports/package_exports.dart';
import '../exports/theme_exports.dart';
import '../exports/page_exports.dart';
import '../exports/util_exports.dart';

class DayWatcher {
  final void Function(DateTime newLogicalDay) onDayChanged;
  final SettingsProvider settingsProvider;
  Timer? _timer;
  late DateTime _lastLogicalDay;

  DayWatcher({required this.onDayChanged, required this.settingsProvider}) {
    _lastLogicalDay = _getLogicalDate(DateTime.now());
    _startListening();
  }

  DateTime _getLogicalDate(DateTime now) {
    final start = _parseHour(settingsProvider.dayStartHour);
    final dayStartDateTime =
        DateTime(now.year, now.month, now.day, start.hour, start.minute);

    if (now.isBefore(dayStartDateTime)) {
      final previousDay = now.subtract(Duration(days: 1));
      return DateTime(previousDay.year, previousDay.month, previousDay.day);
    }

    return DateTime(now.year, now.month, now.day);
  }

  TimeOfDay _parseHour(String hourString) {
    final parts = hourString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  DateTime getLogicalDate(DateTime now) => _getLogicalDate(now);

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
