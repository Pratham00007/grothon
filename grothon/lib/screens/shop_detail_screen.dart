import 'package:flutter/material.dart';
import 'package:grothon/models/wishlistmanger.dart';
import 'package:grothon/screens/cart.dart';
import 'package:grothon/screens/cart_n_checkout.dart.dart';
import 'package:grothon/screens/productdetailscreen.dart';
import 'package:grothon/screens/wishlist.dart';
import '../models/shop.dart';


class ShopDetailScreen extends StatefulWidget {
  final Shop shop;

  const ShopDetailScreen({Key? key, required this.shop}) : super(key: key);

  @override
  _ShopDetailScreenState createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  List<ShopItem> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();
  final CartManager _cartManager = CartManager.instance;
  final WishlistManager _wishlistManager = WishlistManager.instance;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.shop.items;
  }

  void _searchItems(String query) {
    setState(() {
      _filteredItems = query.isEmpty
        ? widget.shop.items
        : widget.shop.items.where((item) => 
            item.name.toLowerCase().contains(query.toLowerCase()) ||
            item.description.toLowerCase().contains(query.toLowerCase())
          ).toList();
    });
  }

  void _addToCart(ShopItem item) {
    _cartManager.addToCart(item);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${item.name} to cart'),
        duration: Duration(seconds: 2),
      )
    );
  }

  void _addToWishlist(ShopItem item) {
    _wishlistManager.addToWishlist(item);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${item.name} to wishlist'),
        duration: Duration(seconds: 2),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              // Sliver App Bar with Image
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    widget.shop.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  background: Image.network(
                    widget.shop.photoUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                actions: [
                  // Cart and Wishlist Icons in App Bar
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      // Navigate to Cart Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartScreen(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite),
                    onPressed: () {
                      // Navigate to Wishlist Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WishlistScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              // Search Bar
              SliverPadding(
                padding: EdgeInsets.all(8),
                sliver: SliverToBoxAdapter(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search items',
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: _searchItems,
                  ),
                ),
              ),
            ];
          },
          body: GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _filteredItems.length,
            itemBuilder: (BuildContext context, int index) {
              final item = _filteredItems[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Image with Click to View Details
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                              product: item,
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                        child: Image.network(
                          item.imageUrl,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    
                    // Item Details
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  item.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${item.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    // Add to Cart Button
                                    IconButton(
                                      icon: Icon(
                                        Icons.shopping_cart,
                                        size: 20,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () => _addToCart(item),
                                    ),
                                    // Add to Wishlist Button
                                    IconButton(
                                      icon: Icon(
                                        Icons.favorite_border,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _addToWishlist(item),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _searchController.dispose();
    super.dispose();
  }
}