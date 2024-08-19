import 'package:flutter/material.dart';
import '../utils/shared_preferences_util.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart'; // Import untuk akses flutterLocalNotificationsPlugin dan scheduleDailyNotification

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isReminderEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadReminderSetting();
  }

  Future<void> _loadReminderSetting() async {
    isReminderEnabled = await getReminderSetting();
    setState(() {});
  }

  Future<void> _toggleReminder(bool value) async {
    setState(() {
      isReminderEnabled = value;
    });
    await saveReminderSetting(value);
    if (value) {
      await scheduleDailyNotification(); // Menjadwalkan notifikasi harian
    } else {
      await flutterLocalNotificationsPlugin.cancel(0); // Membatalkan notifikasi jika reminder dinonaktifkan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListTile(
        title: Text('Daily Reminder'),
        trailing: Switch(
          value: isReminderEnabled,
          onChanged: _toggleReminder,
        ),
      ),
    );
  }
}
