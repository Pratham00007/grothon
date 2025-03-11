// products_list_page.dart
import 'package:flutter/material.dart';
import 'package:grothon/screens/shop/EditProductPage%20.dart';
import 'package:grothon/screens/shop/AddProductPage.dart';
import 'package:grothon/screens/shop/ShopProfilePage.dart';
import 'package:grothon/screens/shop/product_model.dart';
import 'package:intl/intl.dart';


class ProductsListPage extends StatefulWidget {
  final dynamic uid;

  const ProductsListPage({Key? key, required this.uid}) : super(key: key);



  @override
  _ProductsListPageState createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  // Sample product data
  List<Product> products = [
    Product(
      id: '1',
      name: 'Wireless Headphones',
      price: 129.99,
      specifications: 'Bluetooth 5.0, 30-hour battery life, Noise cancellation',
      stock: 15,
      imageUrl: 'assets/images/headphones.jpg',
    ),
    Product(
      id: '2',
      name: 'Smart Watch',
      price: 249.99,
      specifications: 'Heart rate monitor, GPS, Water resistant, 7-day battery',
      stock: 8,
      imageUrl: 'assets/images/smartwatch.jpg',
    ),
    Product(
      id: '3',
      name: 'Bluetooth Speaker',
      price: 79.99,
      specifications: '20W output, Waterproof, 12-hour battery life',
      stock: 20,
      imageUrl: 'assets/images/speaker.jpg',
    ),
  ];

  Future<void> _navigateToEditProduct(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(product: product),
      ),
    );
    
    if (result != null) {
      setState(() {
        final index = products.indexWhere((p) => p.id == result.id);
        if (index >= 0) {
          products[index] = result;
        }
      });
    }
  }

  Future<void> _navigateToAddProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddProductPage(),
      ),
    );
    
    if (result != null) {
      setState(() {
        products.add(result);
      });
    }
  }

  void _navigateToShopProfile() {
    Navigator.push(context,MaterialPageRoute(builder: (context)=> ShopProfilePage(uid:widget.uid,)));
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop Products',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.indigo,
        actions: [
          GestureDetector(
            onTap: _navigateToShopProfile,
            child: Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.store, color: Colors.indigo),
              ),
            ),
          ),
        ],
      ),
      body: products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inventory, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No products yet',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _navigateToAddProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Add First Product'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () => _navigateToEditProduct(product),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // Product image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.image, size: 40, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Product details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  currencyFormat.format(product.price),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'In Stock: ${product.stock}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          // Edit icon
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.indigo),
                            onPressed: () => _navigateToEditProduct(product),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProduct,
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }
}