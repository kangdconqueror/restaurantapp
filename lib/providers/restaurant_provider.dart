import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:restaurantapp/models/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantProvider with ChangeNotifier {
  List<Restaurant> _restaurants = [];
  List<String> _favoriteRestaurantIds = [];

  List<Restaurant> get restaurants => [..._restaurants];
  List<Restaurant> get favoriteRestaurants =>
      _restaurants.where((restaurant) => _favoriteRestaurantIds.contains(restaurant.id)).toList();

  Future<void> fetchRestaurants() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      await _fetchFromUrl();
    } else {
      await _fetchFromLocal();
    }
    await _loadFavorites();
    notifyListeners();
  }

  Future<void> _fetchFromUrl() async {
    final url = 'https://raw.githubusercontent.com/dicodingacademy/assets/main/flutter_fundamental_academy/local_restaurant.json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        _restaurants = (data['restaurants'] as List).map((item) => Restaurant.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load restaurants from URL');
      }
    } catch (error) {
      throw Exception('Failed to load restaurants from URL: $error');
    }
  }

  Future<void> _fetchFromLocal() async {
    try {
      final response = await rootBundle.loadString('assets/local_restaurant.json');
      final data = json.decode(response) as Map<String, dynamic>;
      _restaurants = (data['restaurants'] as List).map((item) => Restaurant.fromJson(item)).toList();
    } catch (error) {
      throw Exception('Failed to load restaurants from local: $error');
    }
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteRestaurantIds = prefs.getStringList('favoriteRestaurants') ?? [];
  }

  Future<void> toggleFavorite(String restaurantId) async {
    if (_favoriteRestaurantIds.contains(restaurantId)) {
      _favoriteRestaurantIds.remove(restaurantId);
    } else {
      _favoriteRestaurantIds.add(restaurantId);
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoriteRestaurants', _favoriteRestaurantIds);
    notifyListeners();
  }

  bool isFavorite(String restaurantId) {
    return _favoriteRestaurantIds.contains(restaurantId);
  }
}
