// main.dart
import 'package:flutter/material.dart';
import 'package:grothon/providers/shop_provider.dart';
import 'package:grothon/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

void main() {
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
      home: HomeScreen(),
    );
  }
}

// models/shop.dart

// providers/shop_provider.dart

// screens/home_screen.dart
// screens/shop_detail_screen.dart

// pubspec.yaml (add these dependencies)
/*
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.3
  geolocator: ^9.0.2
*/
