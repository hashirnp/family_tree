import 'package:family_tree/Screens/add_family_screen.dart';
import 'package:family_tree/Service/Database/Family%20Members/family_members_db.dart';
import 'package:family_tree/Screens/custom_edges.dart';
import 'package:family_tree/model/family_model/family_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../WIdgets/list_item_widget.dart';

// ignore: must_be_immutable
class FamilyMembersScreen extends StatefulWidget with ChangeNotifier {
  FamilyMembersScreen({super.key, required this.familyName});
  final String familyName;

  @override
  State<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
  final grandFatherController = TextEditingController();

  final grandMotherController = TextEditingController();
  late FamilyMembersDB db;

  @override
  void initState() {
    db = FamilyMembersDB(); 
    db.refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: db.familyMembersNotfier,
        builder: (context, list, _) {
          return Scaffold(
              appBar: AppBar(
                title: Text(widget.familyName),
                actions: [
                  if (list.isEmpty)
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: SizedBox(
                                    height: 200,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: grandFatherController,
                                            decoration: const InputDecoration(
                                              label: Text('Name'),
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: grandMotherController,
                                            decoration: const InputDecoration(
                                              label: Text('Spouse'),
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                            onPressed: () async {
                                              FamilyModel familyModel = FamilyModel(
                                                  id: "${grandFatherController.text} & ${grandMotherController.text}",
                                                  next: []);
                                              await db.addFamily(
                                                  model: familyModel);

                                              // ignore: use_build_context_synchronously
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Add'))
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        icon: const Icon(Icons.group)),
                  if (list.isNotEmpty)
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const CustomEdgesPage()));
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.tree,
                        )),
                ],
              ),
              floatingActionButton: list.isNotEmpty
                  ? FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddFamilyScreen(
                                  familyName: widget.familyName,
                                )));
                      },
                      child: const Icon(Icons.add),
                    )
                  : null,
              body: SafeArea(
                  child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (list.isNotEmpty) {
                      return ListItemWidget(model: list[index]);
                    } else {
                      return const Center(
                        child: Text('Add Grand Parents'),
                      );
                    }
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      thickness: 1,
                    );
                  },
                ),
              )));
        });
  }
}
