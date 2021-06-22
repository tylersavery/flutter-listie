import 'package:flutter/material.dart';
import 'package:listie/models/grocery_item.dart';

class GroceryItemCheckbox extends StatefulWidget {
  final GroceryItem groceryItem;

  const GroceryItemCheckbox({
    Key? key,
    required this.groceryItem,
  }) : super(key: key);

  @override
  _GroceryItemCheckboxState createState() => _GroceryItemCheckboxState();
}

class _GroceryItemCheckboxState extends State<GroceryItemCheckbox> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        widget.groceryItem.purchased = !widget.groceryItem.purchased;
        setState(() {});
      },
      icon: Icon(
        widget.groceryItem.purchased
            ? Icons.check_box
            : Icons.check_box_outline_blank,
      ),
    );
  }
}
