import 'package:flutter/material.dart';
import 'package:listie/main.dart';
import 'package:listie/models/grocery_item.dart';
import 'package:listie/screens/list_screen.dart';
import 'package:listie/services/grocery_item_service.dart';
import "package:collection/collection.dart";

abstract class GroceryListProvider extends ChangeNotifier {
  bool ready = false;
  List<GroceryItem> _items = [];

  // Getters
  List<GroceryItem> get items;
  Map<Category?, List<GroceryItem>> get groupedItems;
  List<GroceryItem> get sortedItems;

  // Operations
  Future<void> fetchItems();
  void setItems(List<GroceryItem> items);
  void addItem(GroceryItem item);
  void removeItem(GroceryItem item);
}

class GroceryListProviderImplementation extends GroceryListProvider {
  GroceryListProviderImplementation() {
    _init();
  }

  Future<void> _init() async {
    this.fetchItems();
  }

  Future<void> fetchItems() async {
    final items = await groceryItemService.list();
    this.setItems(items);
    this.ready = true;
    notifyListeners();
  }

  @override
  List<GroceryItem> get items => _items;

  @override
  Map<Category?, List<GroceryItem>> get groupedItems {
    final group =
        groupBy(this._items, (item) => (item as GroceryItem).category);
    return group;
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

    final snackbar = SnackBar(
      content: Text("${item.name} Removed."),
      action: SnackBarAction(
        label: 'Undo',
        textColor: Colors.orange, // or some operation you would like
        onPressed: () async {
          final newItem = await groceryItemService.createFromItem(item);
          _items.add(newItem);
          notifyListeners();
        },
      ),
    );

    rootScaffoldMessengerKey.currentState!.showSnackBar(snackbar);

    groceryItemService.deleteItem(item);
    notifyListeners();
  }

  @override
  List<GroceryItem> get sortedItems {
    final sortedItems = [...this.items];

    sortedItems.sort((a, b) => a.name.compareTo(b.name));
    return sortedItems;
  }
}
