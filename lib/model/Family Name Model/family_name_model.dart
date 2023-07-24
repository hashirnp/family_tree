import 'package:hive_flutter/hive_flutter.dart';
part 'family_name_model.g.dart';

@HiveType(typeId: 0)
class FamilyNameModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  String familyName;
  FamilyNameModel({
    required this.id,
    required this.familyName,
  });
}
