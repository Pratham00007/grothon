import 'package:flutter/material.dart';
import 'package:grothon/screens/user/cart.dart';


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

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartManager _cartManager = CartManager.instance;
  final _formKey = GlobalKey<FormState>();

  // Checkout form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement actual payment processing
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Order Confirmation'),
          content: Text('Your order has been placed successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                // Clear cart and navigate back to main screen
                _cartManager.clearCart();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Summary
                Text(
                  'Order Summary',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _cartManager.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = _cartManager.items[index];
                    return ListTile(
                      title: Text(cartItem.product.name),
                      trailing: Text(
                        '\$${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}',
                      ),
                      subtitle: Text('Qty: ${cartItem.quantity}'),
                    );
                  },
                ),
                Divider(),
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

                SizedBox(height: 24),

                // Shipping Information
                Text(
                  'Shipping Information',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Shipping Address',
                    prefixIcon: Icon(Icons.home),
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your shipping address';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 24),

                // Payment Information
                Text(
                  'Payment Details',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextFormField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(
                    labelText: 'Card Number',
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 16) {
                      return 'Please enter a valid card number';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expiryController,
                        decoration: InputDecoration(
                          labelText: 'Expiry (MM/YY)',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Expiry required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _cvvController,
                        decoration: InputDecoration(
                          labelText: 'CVV',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty || value.length < 3) {
                            return 'Invalid CVV';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // Checkout Button
                ElevatedButton(
                  onPressed: _processPayment,
                  child: Text('Complete Purchase'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}