import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grothon/models/search_results.dart';
import '../models/shop.dart';

class ShopProvider with ChangeNotifier {
  List<Shop> _shops = [
    Shop(
      id: '1',
      name: 'Fresh Mart',
      address: '123 Main St, Cityville',
      photoUrl: 'https://i.ibb.co/GQJkygSp/35e12052442e08febffc529b0d1abdc9.jpg',
      latitude: 40.7128,
      longitude: -74.0060,
      distance: 1.5,
      items: [
        ShopItem(
          id: '1',
          name: 'Organic Apples',
          description: 'Fresh organic red apples',
          price: 2.99,
          imageUrl: 'https://images.pexels.com/photos/102104/pexels-photo-102104.jpeg',
        ),
        ShopItem(
          id: '2',
          name: 'Green Grapes',
          description: 'Crisp green grapes',
          price: 3.49,
          imageUrl: 'https://cdn.pixabay.com/photo/2023/12/07/21/16/grape-8436353_1280.jpg',
        ),
      ],
    ),
    Shop(
      id: '2',
      name: 'Grocery World',
      address: '456 Market St, Townsville',
      photoUrl: 'https://i.ibb.co/60Hb5Zb4/09fcd9225fcf521f3fb7c5e572063eaf.jpg',
      latitude: 40.7300,
      longitude: -74.0100,
      distance: 2.5,
      items: [
        ShopItem(
          id: '3',
          name: 'Red Delicious Apples',
          description: 'Sweet red delicious apples',
          price: 3.29,
          imageUrl: 'https://images.pexels.com/photos/102104/pexels-photo-102104.jpeg',
        ),
      ],
    ),
    // Add more shops and items
  ];

  List<Shop> get shops => _shops;

  Future<void> sortShopsByDistance() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      for (var shop in _shops) {
        shop.distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          shop.latitude,
          shop.longitude,
        ) / 1000; // Convert to kilometers
      }

      _shops.sort((a, b) => (a.distance ?? double.infinity)
          .compareTo(b.distance ?? double.infinity));
      
      notifyListeners();
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  // Enhanced search method to search across all shops and items
  List<SearchResult> searchGlobally(String query) {
    query = query.toLowerCase();
    List<SearchResult> results = [];

    for (var shop in _shops) {
      // Check if shop name matches
      bool shopNameMatches = shop.name.toLowerCase().contains(query);

      // Check if any item in the shop matches
      var matchingItems = shop.items.where((item) => 
        item.name.toLowerCase().contains(query) ||
        item.description.toLowerCase().contains(query)
      ).toList();

      // If shop name or any items match, add to results
      if (shopNameMatches || matchingItems.isNotEmpty) {
        if (shopNameMatches) {
          results.add(SearchResult(
            type: SearchResultType.Shop,
            shop: shop,
            item: null,
          ));
        }

        // Add matching items
        results.addAll(matchingItems.map((item) => SearchResult(
          type: SearchResultType.Item,
          shop: shop,
          item: item,
        )));
      }
    }

    return results;
  }
}
