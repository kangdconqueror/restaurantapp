import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/models/restaurant.dart';

class RestaurantProvider with ChangeNotifier {
  List<Restaurant> _restaurants = [];

  List<Restaurant> get restaurants => _restaurants;

  Future<void> fetchRestaurants() async {
    final response = await http.get(Uri.parse('https://raw.githubusercontent.com/dicodingacademy/assets/main/flutter_fundamental_academy/local_restaurant.json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['restaurants'] as List;
      _restaurants = data.map((json) => Restaurant.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load restaurants');
    }
  }
}
