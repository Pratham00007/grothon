import '../models/shop.dart';

class CartItem {
  final ShopItem product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartManager {
  static final CartManager instance = CartManager._internal();
  factory CartManager() => instance;

  CartManager._internal();

  List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get totalPrice => _items.fold(
    0, 
    (total, item) => total + (item.product.price * item.quantity)
  );

  void addToCart(ShopItem product, [int quantity = 1]) {
    // Check if product already exists in cart
    for (var item in _items) {
      if (item.product == product) {
        item.quantity += quantity;
        return;
      }
    }

    // If not, add new cart item
    _items.add(CartItem(product: product, quantity: quantity));
  }

  void removeFromCart(ShopItem product) {
    _items.removeWhere((item) => item.product == product);
  }

  void updateQuantity(ShopItem product, int newQuantity) {
    for (var item in _items) {
      if (item.product == product) {
        item.quantity = newQuantity;
        break;
      }
    }
  }

  void clearCart() {
    _items.clear();
  }
}