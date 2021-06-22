import 'package:flutter/material.dart';
import 'package:listie/components/grocery_item_checkbox.dart';
import 'package:listie/models/grocery_item.dart';
import 'package:listie/theme.dart';

class GroceryItemCard extends StatelessWidget {
  final GroceryItem groceryItem;

  const GroceryItemCard({
    Key? key,
    required this.groceryItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groceryItem.name,
                  style: ThemeText.bodyText,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  groceryItem.categoryLabel,
                  style: ThemeText.caption,
                ),
              ],
            ),
            GroceryItemCheckbox(
              groceryItem: groceryItem,
            ),
          ],
        ),
      ),
    );
  }
}
