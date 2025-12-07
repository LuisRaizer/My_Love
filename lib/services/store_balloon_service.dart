import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _totalPoppedKey = 'total_popped_balloons';
  static const String _lastMilestoneKey = 'last_milestone_shown';

  static Future<int> getTotalPopped() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalPoppedKey) ?? 0;
  }

  static Future<void> saveTotalPopped(int total) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_totalPoppedKey, total);
  }

  static Future<int> getLastMilestoneShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastMilestoneKey) ?? 0;
  }

  static Future<void> saveLastMilestoneShown(int milestone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastMilestoneKey, milestone);
  }

  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_totalPoppedKey);
    await prefs.remove(_lastMilestoneKey);
  }
}
