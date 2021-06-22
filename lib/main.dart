import 'package:flutter/material.dart';
import 'package:listie/providers/grocery_item_form_provider.dart';
import 'package:listie/providers/grocery_list_provider.dart';
import 'package:listie/screens/add_grocery_item_screen.dart';
import 'package:listie/screens/list_screen.dart';
import 'package:listie/theme.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupSingletons();

  runApp(MyApp());
}

void setupSingletons() {
  getIt.registerSingleton<GroceryItemFormProvider>(
    GroceryItemFormProviderImplementation(),
    signalsReady: true,
  );

  getIt.registerSingleton<GroceryListProvider>(
    GroceryListProviderImplementation(),
    signalsReady: true,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Listie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: ThemeColors.primary,
      ),
      routes: {
        '/': (ctx) => ListScreen(),
        AddGroceryItemScreen.routeName: (ctx) => AddGroceryItemScreen(),
      },
    );
  }
}
