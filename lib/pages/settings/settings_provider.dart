import '../../exports/package_exports.dart';

class SettingsProvider with ChangeNotifier {
  String _dayStartHour = '00:00';
  String get dayStartHour => _dayStartHour;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _dayStartHour = prefs.getString('dayStartHour') ?? '00:00';
  }

  Future<void> setDayStartHour(String hour) async {
    _dayStartHour = hour;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dayStartHour', hour);
  }
}