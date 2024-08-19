import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'daily_reminder_channel_id',
      'Daily Reminder',
      channelDescription: 'Channel for daily reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Example restaurant names
    final List<String> restaurants = [
      'Restaurant A',
      'Restaurant B',
      'Restaurant C',
      // Add more restaurant names here
    ];

    // Get a random restaurant name
    final randomIndex = Random().nextInt(restaurants.length);
    final randomRestaurant = restaurants[randomIndex];

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Daily Restaurant Recommendation',
      'Check out $randomRestaurant today!',
      platformChannelSpecifics,
    );
  }

  Future<void> scheduleDailyNotification() async {
	  var androidChannelId = "1";
	  var androidChannelName = "Restaurant Notifications";
	  var androidChannelDescription = "Notification channel for restaurant updates";

	  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
		androidChannelId,
		androidChannelName,
		channelDescription: androidChannelDescription,
		importance: Importance.max,
		priority: Priority.high,
		showWhen: false,
	  );
	  const NotificationDetails platformChannelSpecifics = NotificationDetails(
		android: androidPlatformChannelSpecifics,
	  );

	  await flutterLocalNotificationsPlugin.zonedSchedule(
		0,
		'Daily Restaurant Reminder',
		'Check out a new restaurant today!',
		_nextInstanceOf11AM(),
		platformChannelSpecifics,
		payload: 'show_random_restaurant',
		androidAllowWhileIdle: true,
		matchDateTimeComponents: DateTimeComponents.time,
	  );
	}

	tz.TZDateTime _nextInstanceOf11AM() {
	  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
	  final tz.TZDateTime scheduledDate = tz.TZDateTime(
		tz.local,
		now.year,
		now.month,
		now.day,
		11,
		0,
	  );

	  if (scheduledDate.isBefore(now)) {
		return scheduledDate.add(Duration(days: 1));
	  } else {
		return scheduledDate;
	  }
	}
}
