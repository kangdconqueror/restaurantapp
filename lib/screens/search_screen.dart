import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import 'restaurant_detail_screen.dart';
import '../widgets/error_widget.dart'; // Pastikan impor ini benar

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load previous search query if any
    final query = Provider.of<RestaurantProvider>(context, listen: false).searchQuery;
    if (query != null) {
      _searchController.text = query;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search restaurant...',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Provider.of<RestaurantProvider>(context, listen: false).searchRestaurants(_searchController.text);
              },
            ),
          ),
          onSubmitted: (value) {
            Provider.of<RestaurantProvider>(context, listen: false).searchRestaurants(value);
          },
        ),
      ),
      body: Consumer<RestaurantProvider>(
        builder: (ctx, restaurantProvider, _) {
          if (restaurantProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (restaurantProvider.errorMessage != null) {
            return CustomErrorWidget(message: restaurantProvider.errorMessage!);
          } else if (restaurantProvider.restaurants.isEmpty) {
            return Center(child: Text('No restaurants found'));
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
      ),
    );
  }
}
