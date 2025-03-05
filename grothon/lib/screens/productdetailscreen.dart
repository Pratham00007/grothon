import 'package:flutter/material.dart';
import 'package:grothon/models/wishlistmanger.dart';
import 'package:grothon/screens/cart.dart';
import '../models/shop.dart';

class ProductDetailScreen extends StatefulWidget {
  final ShopItem product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List<ShopItem> _similarProducts = [];
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _loadSimilarProducts();
  }

  void _loadSimilarProducts() {
    // This is a placeholder. In a real app, you'd fetch similar products 
    // based on category, tags, or other relevant criteria
    setState(() {
      _similarProducts = [
        // Example similar products - replace with actual logic
        ShopItem(
          id: "1",
          name: 'Similar Product 1', 
          description: 'A product similar to the current one', 
          price: 19.99, 
          imageUrl: 'https://example.com/similar1.jpg',
        ),
        ShopItem(
          id: "2",
          name: 'Similar Product 2', 
          description: 'Another similar product', 
          price: 24.99, 
          imageUrl: 'https://example.com/similar2.jpg',
        ),
      ];
    });
  }

  void _addToCart() {
    // Add to cart logic
    CartManager.instance.addToCart(widget.product, _quantity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added to cart'))
    );
  }

  void _addToWishlist() {
    // Add to wishlist logic
    WishlistManager.instance.addToWishlist(widget.product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added to wishlist'))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: _addToWishlist,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Image.network(
              widget.product.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.green,
                    ),
                  ),

                  // Quantity Selector
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Quantity:'),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (_quantity > 1) {
                            setState(() {
                              _quantity--;
                            });
                          }
                        },
                      ),
                      Text('$_quantity'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                      ),
                    ],
                  ),

                  // Add to Cart Button
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addToCart,
                    child: Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),

                  // Similar Products
                  SizedBox(height: 24),
                  Text(
                    'Similar Products',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _similarProducts.length,
                      itemBuilder: (context, index) {
                        final similarProduct = _similarProducts[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                  product: similarProduct,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 150,
                            margin: EdgeInsets.only(right: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  similarProduct.imageUrl,
                                  height: 120,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  similarProduct.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '\$${similarProduct.price.toStringAsFixed(2)}',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}