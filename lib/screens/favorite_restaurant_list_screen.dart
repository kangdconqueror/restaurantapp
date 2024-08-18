import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'restaurant_detail_screen.dart';
import '../providers/restaurant_provider.dart';

class FavoriteListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Restaurants'),
      ),
      body: Consumer<RestaurantProvider>(
        builder: (ctx, restaurantProvider, _) {
          final favoriteRestaurants = restaurantProvider.favoriteRestaurants;
          return favoriteRestaurants.isEmpty
              ? Center(child: Text('No favorites yet!'))
              : ListView.builder(
                  itemCount: favoriteRestaurants.length,
                  itemBuilder: (ctx, index) => Card(
                    margin: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 6,
                          child: Image.network(
                            favoriteRestaurants[index].pictureId,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(favoriteRestaurants[index].name),
                      subtitle: Text(favoriteRestaurants[index].city),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RestaurantDetailScreen(
                              restaurant: favoriteRestaurants[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
        },
      ),
    );
  }
}
