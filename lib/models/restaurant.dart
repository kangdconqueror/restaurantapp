import 'dart:convert';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final List<Category> categories;
  final Menus menus;
  final double rating;
  List<Review> customerReviews;  // Ubah final menjadi variabel biasa

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? '',  // Menangani null
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      pictureId: json['pictureId'] ?? '',
      categories: (json['categories'] as List? ?? [])
          .map((cat) => Category.fromJson(cat))
          .toList(),
      menus: Menus.fromJson(json['menus'] ?? {}), // Menangani null
      rating: (json['rating'] ?? 0).toDouble(),
      customerReviews: (json['customerReviews'] as List? ?? [])
          .map((review) => Review.fromJson(review))
          .toList(),
    );
  }

  void addReview(Review review) {
    customerReviews.add(review);
  }
}

class Category {
  final String name;

  Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json['name'] ?? '');
  }
}

class Menus {
  final List<Food> foods;
  final List<Drink> drinks;

  Menus({required this.foods, required this.drinks});

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      foods: (json['foods'] as List? ?? [])
          .map((item) => Food.fromJson(item))
          .toList(),
      drinks: (json['drinks'] as List? ?? [])
          .map((item) => Drink.fromJson(item))
          .toList(),
    );
  }
}

class Food {
  final String name;

  Food({required this.name});

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(name: json['name'] ?? '');
  }
}

class Drink {
  final String name;

  Drink({required this.name});

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(name: json['name'] ?? '');
  }
}

class Review {
  final String name;
  final String review;
  final String date;

  Review({required this.name, required this.review, required this.date});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      name: json['name'] ?? '',
      review: json['review'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
