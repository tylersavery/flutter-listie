import 'package:flutter/material.dart';
import 'package:listie/components/empty_list_indicator.dart';
import 'package:listie/components/grocery_item_card.dart';
import 'package:listie/main.dart';
import 'package:listie/models/grocery_item.dart';
import 'package:listie/providers/grocery_list_provider.dart';

class GroceryList extends StatefulWidget {
  final Function handleAddItem;
  final bool hidePurchased;
  final bool categorized;
  const GroceryList({
    Key? key,
    required this.handleAddItem,
    this.hidePurchased = false,
    this.categorized = true,
  }) : super(key: key);

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final listProvider = getIt<GroceryListProvider>();

  final _textController = new TextEditingController();

  String _searchQuery = "";

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

  void _onSearchChange(String val) {
    setState(() {
      _searchQuery = val;
    });
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
    List<GroceryItem> listResults = [];

    if (_searchQuery.isNotEmpty) {
      listResults = listProvider.items
          .where(
            (element) =>
                element.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
      if (widget.hidePurchased) {
        listResults = listResults.where((item) => !item.purchased).toList();
      }
    } else if (!widget.categorized) {
      listResults = listProvider.sortedItems;
      if (widget.hidePurchased) {
        listResults = listResults.where((item) => !item.purchased).toList();
      }
    } else if (widget.hidePurchased) {
      groups = {};
      listResults = [];

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

    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
          <Widget>[
        SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              collapsedHeight: 60,
              expandedHeight: 60,
              toolbarHeight: 60,
              leadingWidth: 0,
              backgroundColor: Theme.of(context).primaryColorDark,
              leading: Container(),
              title: TextField(
                controller: _textController,
                style: TextStyle(color: Colors.white70),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.white70,
                  ),
                  icon: Icon(
                    Icons.search,
                    color: Colors.white70,
                  ),
                ),
                onChanged: _onSearchChange,
              ),
            )),
      ],
      body: _searchQuery.isNotEmpty || !widget.categorized
          ? RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                itemCount: listResults.length,
                itemBuilder: (ctx, index) {
                  final item = listResults[index];

                  return GroceryItemCard(
                      groceryItem: item,
                      showCategory: true,
                      onUpdate: () {
                        setState(() {});
                      });
                },
              ),
            )
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                itemCount: groups.length,
                padding: EdgeInsets.only(bottom: 120),
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
                            categoryName != null
                                ? categoryName.toUpperCase()
                                : '-',
                            style:
                                Theme.of(context).textTheme.subtitle1?.copyWith(
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
            ),
    );
  }
}
