import 'package:family_tree/Service/Database/Family%20Members/family_members_db.dart';
import 'package:flutter/material.dart';

import '../model/family_model/family_model.dart';

ValueNotifier<List<FamilyModel>> familyNotifier = ValueNotifier([]);

class TreeService with ChangeNotifier {
  String convertToString() {
    // var json2 = jsonEncode(FamilyMembersDB()
    //     .familyMembersNotfier
    //     .value
    //     .map((e) => e.toJson())
    //     .toList());

    String json = '[';

    // FamilyMembersDB().familyMembersNotfier.value.map((e) {
    //   json += "{\"id\":\"${e.id}\",\"next\":[";
    //   e.next.map((e) {
    //     json += "{\"outcome\":\"${e.outcome}\"}";
    //   }).toList();
    //   json += "]},";
    // }).toList();
    final list = FamilyMembersDB().familyMembersNotfier.value;

    for (int i = 0; i < list.length; i++) {
      json += "{\"id\":\"${list[i].id}\",\"next\":[";
      final next = list[i].next;
      if (next.isNotEmpty) {
        for (int j = 0; j < next.length; j++) {
          json += "{\"outcome\":\"${next[j].outcome}\"}";
          if (j != next.length - 1) {
            json += ",";
          }
        }
      }
      json += "]}";
      if (i != list.length - 1) {
        json += ",";
      }
    }
    json += "]";

    // log('json is \'$json\'');

    // String json = '[';

    // for (int i = 0; i < familyNotifier.value.length; i++) {
    //   if (i != 0) {
    //     json += ',';
    //   }
    //   json += familyNotifier.value[i].toJson();
    // }
    // json += ']';

    // log("'$json2'");
    // log(json2);
    // '['
    // '{"id":"Alavi haji & Mammathu","next":[]}'
    // ']'
    return json;
    // return '[{"id":"Alavi haji & Mammathu","next":[]}]';
  }

  List<String> getParents() {
    // final list = familyNotifier.value;
    // List<String> newList = [];
    // list.map((e) => newList.add(e.id!)).toList();
    // return newList;
    return [];
  }

  editData(
      {required String oldValue,
      required String newValue,
      required String parent}) {
    //change node

    // for (int i = 0; i < familyNotifier.value.length; i++) {
    //   if (familyNotifier.value[i].id == oldValue) {
    //     familyNotifier.value[i].id = newValue;
    //     familyNotifier.notifyListeners();
    //     break;
    //   }
    // }

    // //change new of parent node
    // for (int i = 0; i < familyNotifier.value.length; i++) {
    //   if (familyNotifier.value[i].id == parent) {
    //     final next = familyNotifier.value[i].next;
    //     for (int j = 0; j < next!.length; j++) {
    //       if (next[j].outcome == oldValue) {
    //         familyNotifier.value[i].next![j].outcome = newValue;
    //         familyNotifier.notifyListeners();
    //         break;
    //       }
    //     }
    //     break;
    //   }
    // }
  }

  deleteData({required String parent, required String child}) {
    // //delete oucome from parent node
    // for (int i = 0; i < familyNotifier.value.length; i++) {
    //   if (familyNotifier.value[i].id == parent) {
    //     final next = familyNotifier.value[i].next;
    //     for (int j = 0; j < next!.length; j++) {
    //       if (next[j].outcome == child) {
    //         // for (int k = j; k < next.length - 1; k++) {
    //         //   familyNotifier.value[i].next![k].outcome =
    //         //       familyNotifier.value[i].next![k + 1].outcome;
    //         // }
    //         familyNotifier.value[i].next!.removeAt(j);
    //         break;
    //       }
    //     }
    //     break;
    //   }
    // }

    // //delete node
    // for (int i = 0; i < familyNotifier.value.length; i++) {
    //   if (familyNotifier.value[i].id == child) {
    //     familyNotifier.value.removeAt(i);
    //     break;
    //   }
    // }

    // //notify listeners
    // familyNotifier.notifyListeners();
  }
}
