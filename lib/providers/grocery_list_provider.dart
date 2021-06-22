import 'package:flutter/material.dart';
import 'package:listie/models/grocery_item.dart';
import 'package:listie/services/grocery_item_service.dart';
import "package:collection/collection.dart";

abstract class GroceryListProvider extends ChangeNotifier {
  bool ready = false;
  List<GroceryItem> _items = [];

  // Getters
  List<GroceryItem> get items;
  List<Map<String, dynamic>> get groupedItems;

  // Operations
  void setItems(List<GroceryItem> items);
  void addItem(GroceryItem item);
  void removeItem(GroceryItem item);
}

class GroceryListProviderImplementation extends GroceryListProvider {
  GroceryListProviderImplementation() {
    _init();
  }

  Future<void> _init() async {
    final items = await groceryItemService.list();
    this.setItems(items);
    this.ready = true;
    notifyListeners();
  }

  @override
  List<GroceryItem> get items => _items;

  @override
  List<Map<String, dynamic>> get groupedItems {
    final group =
        groupBy(this._items, (item) => (item as GroceryItem).category);
    print(group);
    return [];
  }

  @override
  void addItem(GroceryItem item) {
    _items.add(item);
    notifyListeners();
  }

  @override
  void setItems(List<GroceryItem> items) {
    _items = items;
    notifyListeners();
  }

  @override
  void removeItem(GroceryItem item) {
    final index = _items.indexWhere((element) => element.id == item.id);
    _items.removeAt(index);
    notifyListeners();
  }
}
