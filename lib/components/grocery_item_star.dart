import 'package:flutter/material.dart';
import 'package:listie/models/grocery_item.dart';
import 'package:listie/services/grocery_item_service.dart';
import 'package:listie/theme.dart';

class GroceryItemStar extends StatefulWidget {
  final GroceryItem groceryItem;
  final Function onUpdate;

  const GroceryItemStar(
      {Key? key, required this.groceryItem, required this.onUpdate})
      : super(key: key);

  @override
  _GroceryItemStarState createState() => _GroceryItemStarState();
}

class _GroceryItemStarState extends State<GroceryItemStar> {
  @override
  Widget build(BuildContext context) {
    final highlighted =
        widget.groceryItem.starred && !widget.groceryItem.purchased;

    return IconButton(
      onPressed: () {
        widget.groceryItem.starred = !widget.groceryItem.starred;
        setState(() {});
        widget.onUpdate();

        if (widget.groceryItem.starred) {
          groceryItemService.starItem(widget.groceryItem);
        } else {
          groceryItemService.unstarItem(widget.groceryItem);
        }
      },
      icon: Icon(
        highlighted ? Icons.star : Icons.star_outline,
        color: highlighted ? Colors.amber : ThemeColors.text,
      ),
    );
  }
}
