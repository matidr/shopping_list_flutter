import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/groceries_empty.dart';
import 'package:shopping_list/widgets/grocery_item.dart';
import 'package:shopping_list/widgets/loading_spinner.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceriesListScreen extends StatefulWidget {
  const GroceriesListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GroceriesListScreenState();
  }
}

class _GroceriesListScreenState extends State<GroceriesListScreen> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
      'flutter-prep-6466e-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );
    final response = await http.get(url);
    setState(() {
      _isLoading = false;
    });

    if (response.statusCode >= 400) {
      setState(() {
        _error = "Failed to fetch data. Please try again later";
      });
    }

    if (response.body == 'null') {
      return;
    }

    final Map<String, dynamic> listData = json.decode(response.body);
    setState(() {
      _groceryItems = listData.entries
          .map(
            (item) => GroceryItem(
              id: item.key,
              name: item.value['name'],
              quantity: item.value['quantity'],
              category: categories.entries
                  .firstWhere(
                    (element) => element.value.name == item.value['category'],
                  )
                  .value,
            ),
          )
          .toList();
    });
  }

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
    final url = Uri.https(
      'flutter-prep-6466e-default-rtdb.firebaseio.com',
      'shopping-list/${item.id}.json',
    );
    http.delete(url);
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
    Widget widget = LoadingSpinner();
    if (_error != null) {
      widget = Center(child: Text(_error!));
    }

    if (_groceryItems.isEmpty) {
      widget = GroceriesEmpty();
    } else {
      widget = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) => Dismissible(
          background: Container(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.75),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
          key: ValueKey(_groceryItems[index].id),
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          child: GroceryListItem(item: _groceryItems[index]),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: widget,
    );
  }
}
