import 'package:flutter/material.dart';
import 'package:listie/models/grocery_item.dart';
import 'package:listie/services/grocery_item_service.dart';

class GroceryItemCheckbox extends StatefulWidget {
  final GroceryItem groceryItem;
  final Function onUpdate;

  const GroceryItemCheckbox(
      {Key? key, required this.groceryItem, required this.onUpdate})
      : super(key: key);

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
        widget.onUpdate();

        if (widget.groceryItem.purchased) {
          groceryItemService.purchaseItem(widget.groceryItem);
        } else {
          groceryItemService.unpurchaseItem(widget.groceryItem);
        }
      },
      icon: Icon(
        widget.groceryItem.purchased
            ? Icons.check_box
            : Icons.check_box_outline_blank,
      ),
    );
  }
}
