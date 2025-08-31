import 'package:flutter/cupertino.dart';

class GroceriesEmpty extends StatelessWidget {
  const GroceriesEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Text("There aren't any groceries added yet"));
  }
}
