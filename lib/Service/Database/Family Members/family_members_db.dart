import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:family_tree/model/family_model/family_model.dart';
import 'package:family_tree/model/family_model/next.dart';

abstract class FamilyMembersFunctions {
  Future<List<FamilyModel>> getFamilyMembers();
  Future<void> addFamily({required FamilyModel model});
  Future<void> editFamily({
    required FamilyModel model,
  });
  Future<void> deleteFamily({required FamilyModel model});
  Future<void> addMember(
      {required String id,
      required FamilyModel familyModel,
      required Next nextModel,
      required String dbName});

  Future<void> editMember({
    required String newValue,
    required String parent,
    required String oldValue,
    required String dbName,
  });

  Future<FamilyModel?> getMember({required String id});
  Future<void> deleteMember({required Next model, required String parent});
}

class FamilyMembersDB with ChangeNotifier implements FamilyMembersFunctions {
  String? dbname;

  // Private constructor
  FamilyMembersDB._internal();

  static FamilyMembersDB? _instance;

  // Factory constructor to create or return the existing instance
  factory FamilyMembersDB() {
    _instance ??= FamilyMembersDB._internal();
    return _instance!;
  }

  void initDB(String dbName) {
    dbname = dbName;
    // Put your database initialization logic here
  }

  ValueNotifier<List<FamilyModel>> familyMembersNotfier = ValueNotifier([]);

  @override
  Future<void> addFamily({required FamilyModel model}) async {
    final familyDB = await Hive.openBox<FamilyModel>(dbname!);
    await familyDB.put(model.id, model);
    refreshUI();
  }

  @override
  Future<void> deleteFamily({required FamilyModel model}) async {
    final familyDB = await Hive.openBox<FamilyModel>(dbname!);
    familyDB.delete(model.id);
    refreshUI();
  }

  @override
  Future<void> editFamily({required FamilyModel model}) async {
    final familyDB = await Hive.openBox<FamilyModel>(dbname!);
    await familyDB.put(model.id, model);
    refreshUI();
  }

  @override
  Future<List<FamilyModel>> getFamilyMembers() async {
    final familyDB = await Hive.openBox<FamilyModel>(dbname!);
    return familyDB.values.toList();
  }

  Future<void> refreshUI() async {
    final family = await getFamilyMembers();
    familyMembersNotfier.value.clear();
    Future.forEach(family, (FamilyModel model) {
      familyMembersNotfier.value.add(model);
    });
    familyMembersNotfier.notifyListeners();
  }

  @override
  Future<void> addMember(
      {required String id,
      required FamilyModel familyModel,
      required Next nextModel,
      required String dbName}) async {
    //add nextNode to parent node
    final familyDB = await Hive.openBox<FamilyModel>(dbname!);
    final item = familyDB.get(id);
    item!.next.add(nextModel);
    await editFamily(model: item);
    //add next as family
    await addFamily(model: familyModel);
    refreshUI();
  }

  @override
  Future<void> editMember(
      {required String newValue,
      required String parent,
      required String oldValue,
      required String dbName}) async {
    final db = await Hive.openBox<FamilyModel>(dbname!);
    //change nod
    //1 get node
    FamilyModel? oldNode = await getMember(id: oldValue);
    //2 add newNode
    FamilyModel model =
        FamilyModel(id: newValue, next: oldNode != null ? oldNode.next : []);
    await db.put(newValue, model);

    //3 delete that node
    await db.delete(oldValue);

    //change next of parent node
    //1 get parent node
    final parentModel = db.get(parent);
    //2 delete old outcome value

    for (int i = 0; i < parentModel!.next.length; i++) {
      if (parentModel.next[i].outcome == oldValue) {
        parentModel.next[i].outcome = newValue;
        break;
      }
    }
    //3 add new outcome value
    // parentModel.next.add(Next(outcome: newValue));
    editFamily(model: parentModel);
    // // refreshUI();
  }

  @override
  Future<FamilyModel?> getMember({required String id}) async {
    final familyDB = await Hive.openBox<FamilyModel>(dbname!);
    return familyDB.get(id);
  }

  @override
  Future<void> deleteMember(
      {required Next model, required String parent}) async {
    final familyDB = await Hive.openBox<FamilyModel>(dbname!);

    //delete node
    familyDB.delete(model.outcome);

    //delete from parent
    final list = familyDB.values;

    for (int i = 0; i < list.length; i++) {
      if (list.elementAt(i).id == parent) {
        familyDB.get(list.elementAt(i).id)!.next.remove(model);
        break;
      }
    }
    refreshUI();
  }

  Future<FamilyModel?> getFamily({required String id}) async {
    final familyDB = await Hive.openBox<FamilyModel>(dbname!);
    return familyDB.get(id);
  }
}
