import 'package:family_tree/Screens/family_members_screen.dart';
import 'package:family_tree/Service/dbname_provider.dart';
import 'package:family_tree/model/Family%20Name%20Model/family_name_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Service/Database/Family Members/family_members_db.dart';
import '../Service/Database/Family Name/family_name_db.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    FamilyNameDB.instance.refreshUI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Tree Generator'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return const EditDialog();
              });
        },
        child: const Icon(CupertinoIcons.add),
      ),
      body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: FamilyNameDB().familyNameNotfier,
              builder: (context, list, _) {
                if (list.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Family Names Added\nAdd to continue.',
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          final provider = Provider.of<DbNameProvider>(context,
                              listen: false);
                          provider.setArgument(list[index].familyName);
                          FamilyMembersDB().initDB(list[index].familyName);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FamilyMembersScreen(
                                    familyName: list[index].familyName,
                                  )));
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(list[index].familyName),
                            Row(children: [
                              // IconButton(
                              //     onPressed: () {
                              //       showDialog(
                              //           context: context,
                              //           builder: (context) {
                              //             return EditDialog(
                              //               model: list[index],
                              //             );
                              //           });
                              //     },
                              //     icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () async {
                                    await FamilyNameDB.instance
                                        .deleteFamily(model: list[index]);
                                  },
                                  icon: const Icon(Icons.delete))
                            ]),
                          ],
                        ),
                      );
                    });
              })),
    );
  }
}

class EditDialog extends StatefulWidget {
  const EditDialog({super.key, this.model});

  final FamilyNameModel? model;

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      controller.text = widget.model!.familyName;
    }
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
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Family Name',
                  labelText: 'Family Name',
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
          onPressed: () async {
            if (controller.text.isNotEmpty) {
              FamilyNameModel model = FamilyNameModel(
                  id: widget.model == null
                      ? DateTime.now().millisecondsSinceEpoch.toString()
                      : widget.model!.id,
                  familyName: controller.text);

              widget.model == null
                  ? await FamilyNameDB.instance.addFamily(model: model)
                  : await FamilyNameDB.instance.editFamily(model: model);
              // await FamilyNameDB().refreshUI();
            }
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          },
          child:
              widget.model == null ? const Text('Save') : const Text('Update'),
        ),
      ],
    );
  }
}
