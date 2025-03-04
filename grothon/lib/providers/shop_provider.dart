import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grothon/main.dart';
import 'package:grothon/models/shop.dart';

class ShopProvider with ChangeNotifier {
  List<Shop> _shops = [
    Shop(
      id: '1',
      name: 'Fresh Mart',
      address: '123 Main St, Cityville',
      photoUrl: 'https://images.pexels.com/photos/916446/pexels-photo-916446.jpeg',
      latitude: 40.7128,
      longitude: -74.0060,
      items: [
        ShopItem(
          id: '1',
          name: 'Organic Apples',
          description: 'Fresh organic apples',
          price: 2.99,
          imageUrl: 'https://images.pexels.com/photos/102104/pexels-photo-102104.jpeg',
        ),
        // More items...
      ],
    ),
    // More shops...
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

  List<Shop> searchShopsAndItems(String query) {
    query = query.toLowerCase();
    return _shops.where((shop) {
      // Search by shop name
      bool matchesShopName = shop.name.toLowerCase().contains(query);
      
      // Search by item name or description
      bool matchesItems = shop.items.any((item) => 
        item.name.toLowerCase().contains(query) ||
        item.description.toLowerCase().contains(query)
      );

      return matchesShopName || matchesItems;
    }).toList();
  }
}
