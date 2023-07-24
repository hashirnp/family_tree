import 'package:family_tree/Screens/item_detail_screen.dart';
import 'package:flutter/material.dart';

import '../model/family_model/family_model.dart';

class ListItemWidget extends StatelessWidget {
  const ListItemWidget({
    super.key,
    required this.model,
  });

  final FamilyModel model;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        model.id,
      ),
      subtitle: ListView.builder(
          shrinkWrap: true,
          itemCount: model.next.length,
          itemBuilder: (context, index) {
            return Text(model.next[index].outcome);
          }),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ItemDetailScreen(model: model)));
      },
    );
  }
}
