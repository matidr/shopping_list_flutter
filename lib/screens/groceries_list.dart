import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/groceries_empty.dart';
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
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => const NewItem()));

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) {
    final groceryItemIndex = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Grocery deleted', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _groceryItems.insert(groceryItemIndex, item);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget widget = _groceryItems.isEmpty
        ? GroceriesEmpty()
        : ListView.builder(
            itemCount: _groceryItems.length,
            itemBuilder: (context, index) => Dismissible(
              background: Container(
                color: Theme.of(
                  context,
                ).colorScheme.error.withValues(alpha: 0.75),
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
              ),
              key: ValueKey(_groceryItems[index].id),
              onDismissed: (direction) {
                _removeItem(_groceryItems[index]);
              },
              child: GroceryListItem(item: _groceryItems[index]),
            ),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: widget,
    );
  }
}
