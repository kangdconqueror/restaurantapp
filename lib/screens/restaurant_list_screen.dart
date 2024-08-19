import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import 'restaurant_detail_screen.dart';
import 'favorite_restaurant_list_screen.dart';
import 'settings_screen.dart';

class RestaurantListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Restaurant'),
            Text(
              'Recommendation restaurant for you!',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FavoriteListScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(), // Navigasi ke halaman SettingsScreen
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<RestaurantProvider>(context, listen: false).fetchRestaurants(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return CustomErrorWidget(message: 'Failed to load restaurants. Please check your internet connection.');
          } else {
            return Consumer<RestaurantProvider>(
              builder: (ctx, restaurantProvider, _) {
                if (restaurantProvider.errorMessage != null) {
                  return CustomErrorWidget(message: restaurantProvider.errorMessage!);
                } else {
                  return ListView.builder(
                    itemCount: restaurantProvider.restaurants.length,
                    itemBuilder: (ctx, index) => Card(
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.width * 0.4,
                            child: Image.network(
                              'https://restaurant-api.dicoding.dev/images/small/${restaurantProvider.restaurants[index].pictureId}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(restaurantProvider.restaurants[index].name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  restaurantProvider.restaurants[index].city,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.yellow,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  restaurantProvider.restaurants[index].rating.toString(),
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RestaurantDetailScreen(
                                id: restaurantProvider.restaurants[index].id,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
