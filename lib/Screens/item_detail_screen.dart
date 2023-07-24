import 'package:family_tree/Service/Database/Family%20Members/family_members_db.dart';
import 'package:family_tree/model/family_model/family_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Service/dbname_provider.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key, required this.model});
  final FamilyModel model;
  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data'),
      ),
      body: SafeArea(
          child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(10),
        children: [
          Text(
            "Parents : ${model.id}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          if (model.next.isNotEmpty)
            const Text(
              'Children',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (model.next.isNotEmpty)
            ListView.builder(
                itemCount: model.next.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final childData = model.next[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(childData.outcome),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return EditDialog(
                                        textController: textController,
                                        parent: model.id,
                                        value: childData.outcome,
                                      );
                                    });
                              },
                              icon: const Icon(
                                Icons.edit,
                              )),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title:
                                            const Text('Required Confirmation'),
                                        content: const SizedBox(
                                          height: 50,
                                          width: 300,
                                          // alignment: Alignment.center,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Are You Sure...?\nThe Acton can't be retrieve"),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          // Add your dialog actions here
                                          ElevatedButton(
                                            onPressed: () {
                                              FamilyMembersDB().deleteMember(
                                                  model: childData,
                                                  parent: model.id);
                                              
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              icon: const Icon(
                                Icons.delete,
                              )),
                        ],
                      )
                    ],
                  );
                })
        ],
      )),
    );
  }
}

// ignore: must_be_immutable
class EditDialog extends StatefulWidget {
  EditDialog({
    super.key,
    required this.textController,
    required this.parent,
    required this.value,
  });

  TextEditingController textController;
  final String parent;
  String value;

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  @override
  void initState() {
    super.initState();
    widget.textController.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 100,
        width: 300,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: widget.textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // Additional widgets
          ],
        ),
      ),
      actions: [
        // Add your dialog actions here
        ElevatedButton(
          onPressed: () {
            final provider =
                Provider.of<DbNameProvider>(context, listen: false);
            final db = FamilyMembersDB();

            db.editMember(
              newValue: widget.textController.text,
              parent: widget.parent,
              oldValue: widget.value,
              dbName: provider.argument,
            );

            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
