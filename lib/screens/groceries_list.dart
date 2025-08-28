import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/widgets/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceriesListScreen extends StatefulWidget {
  const GroceriesListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GroceriesListScreenState();
  }
}

class _GroceriesListScreenState extends State<GroceriesListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => const NewItem()));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) => groceryItems
            .map((groceryItem) => GroceryListItem(item: groceryItem))
            .toList()[index],
      ),
    );
  }
}
