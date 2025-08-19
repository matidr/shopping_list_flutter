import 'package:flutter/cupertino.dart';
import 'package:shopping_list/models/grocery_item.dart';

class GroceryListItem extends StatelessWidget {
  const GroceryListItem({super.key, required this.item});

  final GroceryItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(width: 20, height: 20, color: item.category.color),
          SizedBox(width: 20),
          Text(item.name),
          Spacer(),
          Text(item.quantity.toString()),
        ],
      ),
    );
  }
}
