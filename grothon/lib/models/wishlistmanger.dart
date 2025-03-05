import '../models/shop.dart';

class WishlistManager {
  static final WishlistManager instance = WishlistManager._internal();
  factory WishlistManager() => instance;

  WishlistManager._internal();

  List<ShopItem> _items = [];

  List<ShopItem> get items => List.unmodifiable(_items);

  void addToWishlist(ShopItem product) {
    // Prevent duplicates
    if (!_items.contains(product)) {
      _items.add(product);
    }
  }

  void removeFromWishlist(ShopItem product) {
    _items.removeWhere((item) => item == product);
  }

  bool isInWishlist(ShopItem product) {
    return _items.contains(product);
  }

  void clearWishlist() {
    _items.clear();
  }
}