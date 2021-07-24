import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listie/models/grocery_item.dart';
import 'package:listie/services/api_service.dart';

class GroceryItemService extends ApiService {
  Future<List<GroceryItem>> list() async {
    final data = await this.get('/items');

    final List<GroceryItem> results = data['results']
        .map<GroceryItem>((json) => GroceryItem.fromJson(json))
        .toList();

    return results;
  }

  Future<GroceryItem> create(String name, Category? category) async {
    final params = {
      'name': name,
      'category': GroceryItem.stringFromCategory(category ?? Category.Misc),
      'purchased': false,
    };

    final data = await this.post('/items', params);
    return GroceryItem.fromJson(data);
  }

  Future<GroceryItem> updateItem(int id, GroceryItem item) async {
    final params = {
      'name': item.name,
      'category': item.categoryValue,
      'purchased': item.purchased,
    };

    final data = await this.put('/items/$id', params);
    return GroceryItem.fromJson(data);
  }

  Future<void> purchaseItem(GroceryItem item) async {
    await this.post('/items/${item.id}/purchase');
  }

  Future<void> unpurchaseItem(GroceryItem item) async {
    await this.post('/items/${item.id}/unpurchase');
  }

  Future<void> starItem(GroceryItem item) async {
    await this.post('/items/${item.id}/star');
  }

  Future<void> unstarItem(GroceryItem item) async {
    await this.post('/items/${item.id}/unstar');
  }

  Future<void> deleteItem(GroceryItem item) async {
    await this.delete('/items/${item.id}');
  }
}

GroceryItemService _export() {
  final service = Provider((ref) => GroceryItemService());
  final container = ProviderContainer();
  return container.read(service);
}

final groceryItemService = _export();
