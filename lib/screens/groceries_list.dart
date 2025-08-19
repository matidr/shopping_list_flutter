import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/widgets/grocery_item.dart';

class GroceriesListScreen extends StatelessWidget {
  const GroceriesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Groceries")),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) => groceryItems
            .map((groceryItem) => GroceryListItem(item: groceryItem))
            .toList()[index],
      ),
    );
  }
}
