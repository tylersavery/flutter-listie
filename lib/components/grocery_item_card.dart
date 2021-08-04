import 'package:flutter/material.dart';
import 'package:listie/components/grocery_item_checkbox.dart';
import 'package:listie/components/grocery_item_star.dart';
import 'package:listie/models/grocery_item.dart';
import 'package:listie/providers/grocery_item_form_provider.dart';
import 'package:listie/providers/grocery_list_provider.dart';
import 'package:listie/screens/add_grocery_item_screen.dart';
import 'package:listie/theme.dart';
import 'package:listie/main.dart';
import 'package:listie/utils/formatting.dart';

class GroceryItemCard extends StatefulWidget {
  final GroceryItem groceryItem;
  final Function onUpdate;
  final bool showCategory;

  const GroceryItemCard({
    Key? key,
    required this.groceryItem,
    required this.onUpdate,
    this.showCategory = false,
  }) : super(key: key);

  @override
  _GroceryItemCardState createState() => _GroceryItemCardState();
}

class _GroceryItemCardState extends State<GroceryItemCard> {
  void _handleEdit() async {
    getIt<GroceryItemFormProvider>().setItem(this.widget.groceryItem);

    await Navigator.of(context).pushNamed(AddGroceryItemScreen.routeName);
    setState(() {});
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(this.widget.groceryItem.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        getIt<GroceryListProvider>().removeItem(this.widget.groceryItem);
      },
      background: Container(
        decoration: BoxDecoration(color: Colors.red),
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _handleEdit,
                icon: Icon(
                  Icons.edit,
                  size: 16,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      normaliseName(widget.groceryItem.name),
                      style: ThemeText.bodyText,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    if (widget.showCategory)
                      Text(
                        widget.groceryItem.categoryLabel
                            .toString()
                            .toUpperCase(),
                        style: ThemeText.caption,
                      ),
                  ],
                ),
              ),
              GroceryItemStar(
                groceryItem: widget.groceryItem,
                onUpdate: () {
                  widget.onUpdate();
                },
              ),
              GroceryItemCheckbox(
                groceryItem: widget.groceryItem,
                onUpdate: () {
                  widget.onUpdate();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
