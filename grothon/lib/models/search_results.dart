import 'package:grothon/models/shop.dart';

enum SearchResultType { Shop, Item }

class SearchResult {
  final SearchResultType type;
  final Shop shop;
  final ShopItem? item;

  SearchResult({
    required this.type,
    required this.shop,
    required this.item,
  });
}