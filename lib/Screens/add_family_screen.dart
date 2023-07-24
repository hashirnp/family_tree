import 'package:family_tree/Service/Database/Family%20Members/family_members_db.dart';
import 'package:family_tree/model/family_model/next.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/family_model/family_model.dart';

class AddFamilyScreen extends StatefulWidget {
  const AddFamilyScreen({super.key, required this.familyName});
  final String familyName;

  @override
  State<AddFamilyScreen> createState() => _AddFamilyScreenState();
}

class _AddFamilyScreenState extends State<AddFamilyScreen> with ChangeNotifier {
  final childController = TextEditingController();
  final childPartnerController = TextEditingController();
  late FamilyMembersDB db;
  List<String> parentList = [" "];
  String? dropdownValue;
  @override
  void initState() {
    super.initState();

    getParents(fisrtStart: true);
    db = FamilyMembersDB();

    db.refreshUI();

    // parentList.addAll(newLsit);
    parentList.sort();
    dropdownValue = parentList.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Members'),
      ),
      body: SafeArea(
          child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black38, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButton<String>(
              value: dropdownValue,
              padding: const EdgeInsets.only(left: 5),
              iconEnabledColor: Colors.white,
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: 16,
              ),
              dropdownColor: Colors.white,
              underline: Container(),
              isExpanded: true,
              icon: const Padding(
                  padding: EdgeInsets.only(
                    right: 5,
                  ),
                  child: Icon(
                    CupertinoIcons.down_arrow,
                    color: Colors.black,
                    size: 22,
                  )),
              elevation: 16,
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: parentList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: childController,
              decoration: const InputDecoration(
                label: Text('Child'),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: childPartnerController,
              decoration: const InputDecoration(
                label: Text('Partner'),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                if (parentList.contains(
                    "${childController.text} & ${childPartnerController.text}")) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Already Exist')));
                } else {
                  Next next = Next(
                      outcome:
                          "${childController.text} & ${childPartnerController.text}");
                  FamilyModel familyModel = FamilyModel(
                      id: "${childController.text} & ${childPartnerController.text}",
                      next: []);

                  childController.clear();
                  childPartnerController.clear();

                  db.addMember(
                      id: dropdownValue!,
                      familyModel: familyModel,
                      nextModel: next,
                      dbName: widget.familyName);
                  parentList.clear();
                  await getParents(fisrtStart: false);
                }
              },
              child: const Text('Add'),
            ),
          )
        ],
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    childController.dispose();
    childPartnerController.dispose();
  }

  Future<void> getParents({required bool fisrtStart}) async {
    FamilyMembersDB db = FamilyMembersDB();
    final list = await db.getFamilyMembers();
    final List<String> parentListDummy = [];
    list.map((e) => parentListDummy.add(e.id)).toList();
    parentList.clear();

    final old = dropdownValue;
    setState(() {
      parentList.addAll(parentListDummy);
      dropdownValue = fisrtStart ? parentList.first : old;
    });
  }
}
