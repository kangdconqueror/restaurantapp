import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/restaurant.dart';
import 'providers/restaurant_provider.dart';
import 'screens/restaurant_list_screen.dart';
import 'utils/shared_preferences_util.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<List<Restaurant>> fetchRestaurants() async {
  final response = await http.get(Uri.parse('https://raw.githubusercontent.com/dicodingacademy/assets/main/flutter_fundamental_academy/local_restaurant.json'));
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['restaurants'];
    return data.map((json) => Restaurant.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load restaurants');
  }
}

Future<void> showNotificationWithRandomRestaurant() async {
  var restaurantList = await fetchRestaurants();
  var randomIndex = Random().nextInt(restaurantList.length);
  var randomRestaurant = restaurantList[randomIndex];

  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    '1',
    'Restaurant Notifications',
    channelDescription: 'Notification channel for restaurant updates',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    'Restaurant Recommendation',
    '${randomRestaurant.name} - ${randomRestaurant.city}',
    platformChannelSpecifics,
  );
}

Future<void> scheduleDailyNotification() async {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  final tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 23, 12);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Daily Restaurant Reminder',
    'Check out a new restaurant today!',
    scheduledDate.isBefore(now) ? scheduledDate.add(Duration(days: 1)) : scheduledDate,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        '1',
        'Restaurant Notifications',
        channelDescription: 'Notification channel for restaurant updates',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

Future<void> handleNotificationPayload(String? payload) async {
  if (payload == 'show_random_restaurant') {
    await showNotificationWithRandomRestaurant();
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    // Your background task logic here.
    // Example: Show notification or perform some work.
    print("Background task executed");
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  // Initialize Flutter Local Notifications Plugin
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      handleNotificationPayload(response.payload);
    },
  );

  // Check and schedule notification if enabled
  bool isReminderEnabled = await getReminderSetting();
  if (isReminderEnabled) {
    await scheduleDailyNotification();
  }

  // Initialize Android Alarm Manager
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RestaurantProvider(),
      child: MaterialApp(
        title: 'Restaurant App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RestaurantListScreen(),
      ),
    );
  }
}
