import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/restaurant.dart';

class RestaurantProvider with ChangeNotifier {
  List<Restaurant> _restaurants = [];
  Restaurant? _restaurantDetail;
  bool _isLoading = false;
  String? _errorMessage;
  String? _searchQuery;

  List<Restaurant> get restaurants => [..._restaurants];
  Restaurant? get restaurantDetail => _restaurantDetail;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get searchQuery => _searchQuery;

  Future<void> fetchRestaurants() async {
    _isLoading = true;
    notifyListeners();

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      await _fetchFromUrl();
    } else {
      _errorMessage = 'No internet connection';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchFromUrl() async {
    final url = 'https://restaurant-api.dicoding.dev/list';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        _restaurants = (data['restaurants'] as List)
            .map((item) => Restaurant.fromJson(item))
            .toList();
      } else {
        _errorMessage = 'Failed to load restaurants';
      }
    } catch (error) {
      _errorMessage = 'Failed to load restaurants: $error';
    }
  }

  Future<void> fetchRestaurantDetail(String id) async {
    _isLoading = true;
    notifyListeners();

    final url = 'https://restaurant-api.dicoding.dev/detail/$id';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        _restaurantDetail = Restaurant.fromJson(data['restaurant']);
        _errorMessage = null; // Clear error message on success
      } else {
        _errorMessage = 'Failed to load restaurant details';
      }
    } catch (error) {
      _errorMessage = 'Failed to load restaurant details: $error';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchRestaurants(String query) async {
    _searchQuery = query;
    _isLoading = true;
    notifyListeners();

    final url = 'https://restaurant-api.dicoding.dev/search?q=$query';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        _restaurants = (data['restaurants'] as List)
            .map((item) => Restaurant.fromJson(item))
            .toList();
      } else {
        _errorMessage = 'Failed to search restaurants';
      }
    } catch (error) {
      _errorMessage = 'Failed to search restaurants: $error';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addReview(String id, String name, String review) async {
    final url = 'https://restaurant-api.dicoding.dev/review';
    final body = json.encode({
      'id': id,
      'name': name,
      'review': review,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['error'] == false) {
          // Update the customerReviews with new review
          final newReview = Review.fromJson({
            'name': name,
            'review': review,
            'date': DateTime.now().toIso8601String(),
          });
          _restaurantDetail?.customerReviews.add(newReview);

          _errorMessage = null; // Clear error message on success
          // Optionally, reload the restaurant details to ensure up-to-date data
          await fetchRestaurantDetail(id);

          notifyListeners();
        } else {
          _errorMessage = 'Failed to add review: ${data['message']}'; // Include detailed message if available
        }
      } else {
        _errorMessage = 'Failed to add review: ${response.reasonPhrase}';
      }
    } catch (error) {
      _errorMessage = 'Failed to add review: $error';
    }
  }
}
