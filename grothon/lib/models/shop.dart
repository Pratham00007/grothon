class Shop {
  final String id;
  final String name;
  final String address;
  final String photoUrl;
  final double latitude;
  final double longitude;
  final List<ShopItem> items;
  double? distance;

  Shop({
    required this.id,
    required this.name,
    required this.address,
    required this.photoUrl,
    required this.latitude,
    required this.longitude,
    required this.items,
    this.distance,
  });
}

class ShopItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}
