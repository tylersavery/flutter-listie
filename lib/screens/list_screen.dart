import 'package:flutter/material.dart';
import 'package:listie/components/grocery_list.dart';
import 'package:listie/main.dart';
import 'package:listie/providers/grocery_item_form_provider.dart';
import 'package:listie/providers/grocery_list_provider.dart';
import 'package:listie/screens/add_grocery_item_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final listProvider = getIt<GroceryListProvider>();

  bool hidePurchased = false;
  bool categorized = true;

  void _handleAddItem() {
    getIt<GroceryItemFormProvider>().clearItem();
    Navigator.of(context).pushNamed(AddGroceryItemScreen.routeName);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listie"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  categorized = !categorized;
                });
              },
              icon: Icon(
                  !categorized ? Icons.sort_outlined : Icons.sort_by_alpha)),
          IconButton(
            onPressed: () {
              setState(() {
                hidePurchased = !hidePurchased;
              });
            },
            icon: Icon(
              !hidePurchased ? Icons.check_box : Icons.check_box_outline_blank,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleAddItem,
        child: Icon(Icons.add),
      ),
      body: GroceryList(
        handleAddItem: _handleAddItem,
        hidePurchased: hidePurchased,
        categorized: categorized,
      ),
    );
  }
}
