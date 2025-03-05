import 'package:flutter/material.dart';
import 'package:grothon/models/search_results.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';
import 'shop_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> _searchResults = [];

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    setState(() {
      _searchResults = shopProvider.searchGlobally(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
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
                onChanged: _performSearch,
              ),
            ),

            // Dynamic Search Results or Shops List
            Expanded(
              child: _searchResults.isNotEmpty
                  ? _buildSearchResultsList()
                  : _buildShopsList(shopProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultsList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 8),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        
        return Card(
          margin: EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                result.type == SearchResultType.Shop 
                  ? result.shop.photoUrl  // Use shop photo for shops
                  : result.item!.imageUrl,  // Use item image for items
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            title: Text(
              result.type == SearchResultType.Shop 
                ? result.shop.name 
                : result.item!.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              result.type == SearchResultType.Shop 
                ? result.shop.address 
                : result.item!.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              result.type == SearchResultType.Item
                ? '\$${result.item!.price.toStringAsFixed(2)}'
                : '',
              style: TextStyle(color: Colors.green),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShopDetailScreen(shop: result.shop),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Rest of the code remains the same as in the previous implementation
  // ... (previously shown _buildShopsList method)
}
  Widget _buildShopsList(ShopProvider shopProvider) {
    return RefreshIndicator(
      onRefresh: () async {
        await shopProvider.sortShopsByDistance();
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 8),
        itemCount: shopProvider.shops.length,
        itemBuilder: (context, index) {
          final shop = shopProvider.shops[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShopDetailScreen(shop: shop),
                ),
              );
            },
            child: Container(
              height: 270, // Fixed height to prevent overflow
              margin: EdgeInsets.only(bottom: 10),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Shop Image
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: Image.network(
                        shop.photoUrl,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 180,
                            color: Colors.grey[300],
                            child: Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                    ),
                    
                    // Shop Details
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shop.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            shop.address,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          if (shop.distance != null)
                            Text(
                              '${shop.distance!.toStringAsFixed(2)} km',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
