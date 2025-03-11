// shop_profile_page.dart
import 'package:flutter/material.dart';
import 'package:grothon/screens/login%20and%20signup/login.dart';
import 'package:grothon/screens/login%20and%20signup/shopkeeper_login_fire.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ShopProfilePage extends StatefulWidget {
  final dynamic uid;

  const ShopProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  _ShopProfilePageState createState() => _ShopProfilePageState();
}

class _ShopProfilePageState extends State<ShopProfilePage> {
  final _formKey = GlobalKey<FormState>();
  File? _shopImage;
  final ImagePicker _picker = ImagePicker();
  bool isloading = false;

  // Form controllers
  final TextEditingController _shopNameController =
      TextEditingController(text: "My Shop");
  final TextEditingController _locationController =
      TextEditingController(text: "123 Main Street, City");
  final TextEditingController _phoneController =
      TextEditingController(text: "+1 234 567 8900");
  final TextEditingController _emailController =
      TextEditingController(text: "shop@example.com");
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _shopImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Shop Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                            )
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: _shopImage != null
                            ? ClipOval(
                                child: Image.file(
                                  _shopImage!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.store,
                                size: 80, color: Colors.indigo),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 4, color: Colors.white),
                            color: Colors.indigo,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.edit, size: 20),
                            color: Colors.white,
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Shop Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _shopNameController,
                  decoration: InputDecoration(
                    labelText: 'Shop Name',
                    prefixIcon: const Icon(Icons.store),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a shop name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    prefixIcon: const Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (_passwordController.text.isNotEmpty &&
                        value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Save user information
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Profile updated successfully')),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Submit button
                SizedBox(
                  height: 56,
                  child: isloading
                      ? LinearProgressIndicator()
                      // ? Transform.scale(
                      //     scale: 0.3,
                      //     child: CircularProgressIndicator(),
                      //     )
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isloading = true;
                            });
                            await ShopKeeperAuthenticationService().signOut();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => WelcomePage()));
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(56),
                            backgroundColor:
                                const Color.fromARGB(255, 230, 15, 0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "SignOut",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
