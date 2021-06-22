import 'package:flutter/material.dart';
import 'package:listie/models/grocery_item.dart';
import 'package:listie/services/grocery_item_service.dart';

abstract class GroceryListProvider extends ChangeNotifier {
  bool ready = false;
  List<GroceryItem> _items = [];

  // Getters
  List<GroceryItem> get items;

  // Operations
  void setItems(List<GroceryItem> items);
  void addItem(GroceryItem item);
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
  void addItem(GroceryItem item) {
    _items.add(item);
    notifyListeners();
  }

  @override
  void setItems(List<GroceryItem> items) {
    _items = items;
    notifyListeners();
  }
}
