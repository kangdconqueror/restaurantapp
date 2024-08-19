import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'restaurant_detail_screen.dart';
import '../providers/restaurant_provider.dart';

class FavoriteListScreen extends StatefulWidget {
  @override
  _FavoriteListScreenState createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Restaurants'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<RestaurantProvider>(
        builder: (ctx, restaurantProvider, _) {
          final favoriteRestaurants = restaurantProvider.favoriteRestaurants
              .where((restaurant) => restaurant.name
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
              .toList();
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
