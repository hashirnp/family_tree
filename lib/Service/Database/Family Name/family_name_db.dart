import 'package:family_tree/model/family_model/family_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../model/Family Name Model/family_name_model.dart';

const familyNames = 'family_names';

abstract class FamilyNameDBFunctions {
  Future<List<FamilyNameModel>> getFamilyNames();
  Future<void> addFamily({required FamilyNameModel model});
  Future<void> editFamily({
    required FamilyNameModel model,
  });
  Future<void> deleteFamily({required FamilyNameModel model});
}

class FamilyNameDB with ChangeNotifier implements FamilyNameDBFunctions {
  FamilyNameDB._internal();

  static FamilyNameDB instance = FamilyNameDB._internal();
  factory FamilyNameDB() {
    return instance;
  }
  ValueNotifier<List<FamilyNameModel>> familyNameNotfier = ValueNotifier([]);

  @override
  Future<void> addFamily({required FamilyNameModel model}) async {
    final familyDB = await Hive.openBox<FamilyNameModel>(familyNames);
    await familyDB.put(model.id, model);
    refreshUI();
  }

  @override
  Future<void> deleteFamily({required FamilyNameModel model}) async {
    final familyDB = await Hive.openBox<FamilyNameModel>(familyNames);
    familyDB.delete(model.id);
    final family = await Hive.openBox<FamilyModel>(model.familyName);

    await family.clear();
    refreshUI();
  }

  @override
  Future<void> editFamily({required FamilyNameModel model}) async {
    final familyDB = await Hive.openBox<FamilyNameModel>(familyNames);
    await familyDB.put(model.id, model);
    refreshUI();
  }

  @override
  Future<List<FamilyNameModel>> getFamilyNames() async {
    final familyDB = await Hive.openBox<FamilyNameModel>(familyNames);
    return familyDB.values.toList();
  }

  Future<void> refreshUI() async {
    final family = await getFamilyNames();
    familyNameNotfier.value.clear();
    Future.forEach(family, (FamilyNameModel model) {
      familyNameNotfier.value.add(model);
    });
    familyNameNotfier.notifyListeners();
  }
}
