import 'package:shared_preferences/shared_preferences.dart';

// Key untuk menyimpan pengaturan reminder
const String _reminderEnabledKey = 'reminder_enabled';

// Menyimpan pengaturan reminder
Future<void> saveReminderSetting(bool isEnabled) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_reminderEnabledKey, isEnabled);
}

// Mengambil pengaturan reminder
Future<bool> getReminderSetting() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_reminderEnabledKey) ?? false;
}

// Menghapus pengaturan reminder (opsional)
Future<void> removeReminderSetting() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(_reminderEnabledKey);
}
