import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import '../models/restaurant.dart';
import '../widgets/error_widget.dart'; // Assuming you have this file

class RestaurantDetailScreen extends StatefulWidget {
  final String id;

  RestaurantDetailScreen({required this.id});

  @override
  _RestaurantDetailScreenState createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RestaurantProvider>(context, listen: false).fetchRestaurantDetail(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Detail'),
      ),
      body: Consumer<RestaurantProvider>(
        builder: (ctx, restaurantProvider, _) {
          if (restaurantProvider.errorMessage != null) {
            return CustomErrorWidget(message: restaurantProvider.errorMessage!);
          } else {
            final restaurant = restaurantProvider.restaurantDetail;
            if (restaurant == null) {
              return Center(child: Text('Restaurant not found'));
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 6 / 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      restaurant.name,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_pin, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          restaurant.city,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow),
                        SizedBox(width: 4),
                        Text(
                          restaurant.rating.toString(),
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      restaurant.description,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Menus',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Foods:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: restaurant.menus.foods.map((food) {
                        return Chip(
                          label: Text(food.name, style: TextStyle(color: Colors.black)),
                          backgroundColor: Colors.lightBlueAccent,
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 8),
                    Text('Drinks:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: restaurant.menus.drinks.map((drink) {
                        return Chip(
                          label: Text(drink.name, style: TextStyle(color: Colors.black)),
                          backgroundColor: Colors.lightBlueAccent,
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                    Text('Reviews', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: restaurant.customerReviews.length,
                      itemBuilder: (ctx, index) {
                        final review = restaurant.customerReviews[index];
                        return ListTile(
                          title: Text(review.name),
                          subtitle: Text(review.review),
                          trailing: Text(review.date),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    Text('Add a Review', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Your Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _reviewController,
                            decoration: InputDecoration(
                              labelText: 'Your Review',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your review';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final name = _nameController.text;
                                final review = _reviewController.text;

                                try {
                                  await Provider.of<RestaurantProvider>(context, listen: false).addReview(
                                    widget.id,
                                    name,
                                    review,
                                  );

                                  // Clear the text fields
                                  _nameController.clear();
                                  _reviewController.clear();

                                  // Show success notification
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Review added successfully!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } catch (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to add review: $error'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            icon: Icon(Icons.send),
                            label: Text('Submit Review'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              textStyle: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
