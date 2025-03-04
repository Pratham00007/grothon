
import 'package:flutter/material.dart';
import 'package:grothon/models/shop.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';
import 'shop_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Shop> _filteredShops = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShopProvider>(context, listen: false).sortShopsByDistance();
    });
  }

  void _searchShops(String query) {
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    setState(() {
      _filteredShops = query.isEmpty 
        ? shopProvider.shops 
        : shopProvider.searchShopsAndItems(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final shops = _filteredShops.isEmpty 
      ? shopProvider.shops 
      : _filteredShops;

    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Shops'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search shops or items',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onChanged: _searchShops,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: shops.length,
              itemBuilder: (context, index) {
                final shop = shops[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        shop.photoUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      shop.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(shop.address),
                        if (shop.distance != null)
                          Text(
                            '${shop.distance!.toStringAsFixed(2)} km away',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                      ],
                    ),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShopDetailScreen(shop: shop),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
