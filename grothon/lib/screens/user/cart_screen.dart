import 'package:flutter/material.dart';
import 'package:grothon/screens/user/cart.dart';
import 'package:grothon/screens/user/checkout.dart';


class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartManager _cartManager = CartManager.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... (previous implementation continues)
       appBar: AppBar(
        title: Text('My Cart'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: () {
              setState(() {
                _cartManager.clearCart();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _cartManager.items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 100,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Your cart is empty',
                        style: Theme.of(context).textTheme.bodyMedium
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _cartManager.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = _cartManager.items[index];
                    return ListTile(
                      leading: Image.network(
                        cartItem.product.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      title: Text(cartItem.product.name),
                      subtitle: Text('\$${cartItem.product.price.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (cartItem.quantity > 1) {
                                  _cartManager.updateQuantity(
                                    cartItem.product, 
                                    cartItem.quantity - 1
                                  );
                                } else {
                                  _cartManager.removeFromCart(cartItem.product);
                                }
                              });
                            },
                          ),
                          Text('${cartItem.quantity}'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                _cartManager.updateQuantity(
                                  cartItem.product, 
                                  cartItem.quantity + 1
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
          ),
            ]
            ),      // Bottom Cart Summary and Checkout
      bottomNavigationBar: _cartManager.items.isNotEmpty
        ? Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${_cartManager.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(),
                      ),
                    );
                  },
                  child: Text('Proceed to Checkout'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          )
        : null,
    );
  }
}
