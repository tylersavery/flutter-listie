import 'package:flutter/material.dart';
import 'package:listie/models/grocery_item.dart';
import 'package:listie/services/grocery_item_service.dart';

abstract class GroceryItemFormProvider extends ChangeNotifier {
  GroceryItem _groceryItem = GroceryItem();

  bool _isProcessing = false;
  GlobalKey<FormState> _form = GlobalKey<FormState>();

  // Getters
  GroceryItem get groceryItem;
  bool get isProcessing;
  GlobalKey<FormState> get form;

  // Operations
  void clearItem();
  void loadItem(GroceryItem item);
  Future<GroceryItem?> saveItem();

  // Validation
  String? validateName(String? value);

  // Values
  void setName(String name);
  void setCategory(Category? category);
}

class GroceryItemFormProviderImplementation extends GroceryItemFormProvider {
  // GroceryItemFormProviderImplementation() {}

  void handleUpdate() {
    this.notifyListeners();
  }

  @override
  void clearItem() {
    this._groceryItem = GroceryItem();
    this.handleUpdate();
  }

  @override
  GlobalKey<FormState> get form => _form;

  @override
  GroceryItem get groceryItem => _groceryItem;

  @override
  bool get isProcessing => _isProcessing;

  @override
  void loadItem(GroceryItem item) async {
    this._groceryItem = item;
    this.handleUpdate();
  }

  @override
  Future<GroceryItem?> saveItem() async {
    if (!_form.currentState!.validate()) {
      this.handleUpdate();
      return null;
    }

    _isProcessing = true;
    this.handleUpdate();

    final newGroceryItem = await groceryItemService.create(
      this._groceryItem.name,
      this._groceryItem.category,
    );

    _isProcessing = false;

    this.handleUpdate();
    return newGroceryItem;
  }

  @override
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Item name is required";
    }
    return null;
  }

  @override
  void setName(String name) {
    this._groceryItem.name = name;
    this.handleUpdate();
  }

  @override
  void setCategory(Category? category) {
    this._groceryItem.category = category;
    this.handleUpdate();
  }
}
