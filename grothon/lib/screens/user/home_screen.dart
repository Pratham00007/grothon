import 'package:flutter/material.dart';
import 'package:grothon/models/search_results.dart';
import 'package:grothon/screens/shop/profile_screen.dart';
import 'package:grothon/screens/user/cart_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/shop_provider.dart';
import 'shop_detail_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> _searchResults = [];
  int _selectedIndex = 0;


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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on selected index
    if (index == 1) {
      // Navigate to Cart page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartScreen()),
      ).then((_) => setState(() => _selectedIndex = 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        title: Text('Grothon', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: _buildDrawer(context),
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

      
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            accountName: Text('John Doe'),
            accountEmail: Text('john.doe@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://via.placeholder.com/150',
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.indigo),
            title: Text('My Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart, color: Colors.indigo),
            title: Text('My Cart'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.indigo),
            title: Text('Wishlist'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Wishlist screen
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.history, color: Colors.indigo),
            title: Text('Order History'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Order History screen
            },
          ),
          ListTile(
            leading: Icon(Icons.help, color: Colors.indigo),
            title: Text('Help & Support'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Help & Support screen
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.contact_mail, color: Colors.indigo),
            title: Text('Reach Us'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Contact screen
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.indigo),
            title: Text('Sign Out'),
            onTap: () {
              Navigator.pop(context);
              // Implement sign out logic
            },
          ),
        ],
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
}

