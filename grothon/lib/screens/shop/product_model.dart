// models/product.dart
class Product {
  final String id;
  final String name;
  final double price;
  final String specifications;
  final int stock;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.specifications,
    required this.stock,
    required this.imageUrl,
  });

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? specifications,
    int? stock,
    String? imageUrl,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      specifications: specifications ?? this.specifications,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}