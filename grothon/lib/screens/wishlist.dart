import 'package:flutter/material.dart';
import 'package:grothon/models/wishlistmanger.dart';
import 'package:grothon/screens/cart.dart';
import 'package:grothon/screens/productdetailscreen.dart';


class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final WishlistManager _wishlistManager = WishlistManager.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wishlist'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: () {
              setState(() {
                _wishlistManager.clearWishlist();
              });
            },
          ),
        ],
      ),
      body: _wishlistManager.items.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 100,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Your wishlist is empty',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: _wishlistManager.items.length,
            itemBuilder: (context, index) {
              final product = _wishlistManager.items[index];
              return ListTile(
                leading: Image.network(
                  product.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                title: Text(product.name),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        setState(() {
                          _wishlistManager.removeFromWishlist(product);
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        // Add to cart and remove from wishlist
                        CartManager.instance.addToCart(product);
                        _wishlistManager.removeFromWishlist(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to cart'))
                        );
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(product: product),
                    ),
                  );
                },
              );
            },
          ),
    );
  }
}