import 'package:flutter/material.dart';
import 'package:listie/components/empty_list_indicator.dart';
import 'package:listie/components/grocery_item_card.dart';
import 'package:listie/main.dart';
import 'package:listie/models/grocery_item.dart';
import 'package:listie/providers/grocery_list_provider.dart';

class GroceryList extends StatefulWidget {
  final Function handleAddItem;
  final bool hidePurchased;
  const GroceryList({
    Key? key,
    required this.handleAddItem,
    this.hidePurchased = false,
  }) : super(key: key);

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final listProvider = getIt<GroceryListProvider>();

  @override
  void initState() {
    super.initState();

    listProvider.addListener(() {
      setStateIfMounted(() {});
    });
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future<void> _refreshData() async {
    await listProvider.fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    final items = listProvider.items;

    if (!listProvider.ready) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (items.length == 0) {
      return Center(
        child: EmptyListIndicator(
          title: "No Grocery Items",
          buttonText: "Add Item",
          onButtonPressed: widget.handleAddItem,
        ),
      );
    }

    Map<Category?, List<GroceryItem>> groups = listProvider.groupedItems;

    if (widget.hidePurchased) {
      groups = {};

      listProvider.groupedItems.keys.forEach((key) {
        final items = listProvider.groupedItems[key];

        bool shouldInclude = false;
        items!.forEach((item) {
          if (!item.purchased) {
            shouldInclude = true;
          }
        });

        if (shouldInclude) {
          groups[key] = items;
        }
      });
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (ctx, index) {
          final key = groups.keys.elementAt(index);
          final group = groups[key];

          final filteredGroup = widget.hidePurchased
              ? group!.where((element) => !element.purchased)
              : group;

          String? categoryName =
              key != null ? GroceryItem.stringFromCategory(key) : null;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.black87,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    categoryName != null ? categoryName.toUpperCase() : '-',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
              ...filteredGroup!.map((item) {
                return GroceryItemCard(
                    groceryItem: item,
                    onUpdate: () {
                      setState(() {});
                    });
              }).toList()
            ],
          );
        },
      ),
    );
  }
}
