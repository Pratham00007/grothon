// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grothon/providers/shop_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grothon/screens/login%20and%20signup/shopkeeper_login.dart';
import 'package:grothon/screens/shop/ProductsListPage%20.dart';
import 'package:grothon/screens/shop/ShopProfilePage.dart';
import 'firebase_options.dart';

import 'package:grothon/screens/login%20and%20signup/login.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: "grothon/.env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ShopProvider()),
      ],
      child: ShoppingApp(),
    ),
  );
}

class ShoppingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Shops',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: WelcomePage(),
    );
  }
}
