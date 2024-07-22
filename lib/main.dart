import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/restaurant.dart';
import 'providers/restaurant_provider.dart';
import 'screens/restaurant_list_screen.dart';

void main() {
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
