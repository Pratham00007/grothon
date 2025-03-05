import 'package:flutter/material.dart';
import 'package:grothon/models/search_results.dart';
import '../providers/shop_provider.dart';
import 'shop_detail_screen.dart';

class GlobalSearchResultsScreen extends StatelessWidget {
  final List<SearchResult> searchResults;

  const GlobalSearchResultsScreen({Key? key, required this.searchResults}) 
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final result = searchResults[index];
          
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: result.type == SearchResultType.Shop
                ? Icon(Icons.store, color: Colors.blue)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      result.item!.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
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
      ),
    );
  }
}
