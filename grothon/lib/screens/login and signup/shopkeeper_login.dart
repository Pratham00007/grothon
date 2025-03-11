import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grothon/screens/login%20and%20signup/shopkeeper_login_fire.dart';
import 'package:grothon/screens/shop/ProductsListPage%20.dart';
import 'package:image_picker/image_picker.dart';

class ShopkeeperAuthPage extends StatefulWidget {
  final bool isLogin;

  const ShopkeeperAuthPage({Key? key, required this.isLogin}) : super(key: key);

  @override
  State<ShopkeeperAuthPage> createState() => _ShopkeeperAuthPageState();
}

class _ShopkeeperAuthPageState extends State<ShopkeeperAuthPage> {
  File? _shopImage;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailcont = TextEditingController();
  final TextEditingController passcont = TextEditingController();
  final TextEditingController shopnamecont = TextEditingController();
  final TextEditingController phnocont = TextEditingController();
  final TextEditingController shopaddcont = TextEditingController();
  final TextEditingController psresetcont = TextEditingController();
  bool isLoading = false;

  void despose() {
    super.dispose();
    emailcont.dispose();
    passcont.dispose();
    shopnamecont.dispose();
    phnocont.dispose();
    shopaddcont.dispose();
    psresetcont.dispose();
  }

  signUpShopkeeper() async {
    String res = await ShopKeeperAuthenticationService().SignupShop(
        email: emailcont.text,
        password: passcont.text,
        shopName: shopnamecont.text,
        shopAddress: shopaddcont.text,
        phone_num: phnocont.text);
    if (res == "Success") {
      // navigate to next screen
      setState(() {
        isLoading = false;
        
      });
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProductsListPage()));
    } else {
      setState(() {
        isLoading = false;
      });
      return ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(res)));
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _shopImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo[600]!, Colors.indigo[900]!],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Shop image section (only for registration)
                      if (!widget.isLogin) ...[
                        // Shop icon/profile
                        Align(
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.indigo[50],
                                  shape: BoxShape.circle,
                                  image: _shopImage != null
                                      ? DecorationImage(
                                          image: FileImage(_shopImage!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: _shopImage == null
                                    ? Icon(
                                        Icons.storefront,
                                        size: 60,
                                        color: Colors.indigo[800],
                                      )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo[800],
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ] else ...[
                        // Login icon
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.indigo[50],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.storefront,
                              size: 48,
                              color: Colors.indigo[800],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Header text
                      Text(
                        widget.isLogin ? 'Welcome Back!' : 'Register Your Shop',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.isLogin
                            ? 'Sign in to manage your shop'
                            : 'Create an account to list your products',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Form
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Registration fields
                            if (!widget.isLogin) ...[
                              _buildTextField(
                                contr: shopnamecont,
                                label: 'Shop Name',
                                hint: 'Enter your shop name',
                                icon: Icons.store,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter shop name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                contr: shopaddcont,
                                label: 'Location',
                                hint: 'Enter shop location',
                                icon: Icons.location_on,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter shop location';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                contr: phnocont,
                                label: 'WhatsApp Number',
                                hint: 'Enter WhatsApp number',
                                icon: Icons.phone,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter WhatsApp number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Common fields for both login and registration
                            _buildTextField(
                              contr: emailcont,
                              label: 'Email',
                              hint: 'Enter your email',
                              icon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              contr: passcont,
                              label: 'Password',
                              hint: 'Enter your password',
                              icon: Icons.lock,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),

                            if (widget.isLogin) ...[
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    _showForgotPasswordDialog(context);
                                  },
                                  child: const Text('Forgot Password?'),
                                ),
                              ),
                            ],

                            const SizedBox(height: 24),

                            // Submit button
                            SizedBox(
                              height: 56,
                              child: isLoading
                              ? LinearProgressIndicator()
                                  // ? Transform.scale(
                                  //     scale: 0.3,
                                  //     child: CircularProgressIndicator(),
                                  //     )
                                  : ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        signUpShopkeeper();
                                        // if (_formKey.currentState!.validate()) {
                                        //   // Handle login or registration logic
                                        //   ScaffoldMessenger.of(context).showSnackBar(
                                        //     SnackBar(
                                        //       content: Text(
                                        //         widget.isLogin
                                        //             ? 'Login Successful!'
                                        //             : 'Registration Successful!',
                                        //       ),
                                        //     ),
                                        //   );
                                        // }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.indigo[800],
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        widget.isLogin ? 'Login' : 'Register',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            ),

                            const SizedBox(height: 24),

                            // Login/Register switch
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.isLogin
                                      ? "Don't have an account?"
                                      : 'Already have an account?',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ShopkeeperAuthPage(
                                          isLogin: !widget.isLogin,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    widget.isLogin ? 'Register' : 'Login',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController contr,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: contr,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.indigo),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.indigo[800]!, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
          validator: validator,
        ),
      ],
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your email address and we will send you a link to reset your password',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: psresetcont,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.email),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle password reset logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password reset link sent to your email!'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo[800],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Send Link'),
          ),
        ],
      ),
    );
  }
}
