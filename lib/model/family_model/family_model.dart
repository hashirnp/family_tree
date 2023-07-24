import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'next.dart';

part 'family_model.g.dart';

// @JsonSerializable()
@HiveType(typeId: 1)
class FamilyModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  List<Next> next;
  FamilyModel({
    required this.id,
    required this.next,
  });

 

  FamilyModel copyWith({
    String? id,
    List<Next>? next,
  }) {
    return FamilyModel(
      id: id ?? this.id,
      next: next ?? this.next,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'next': next.map((x) => x.toMap()).toList(),
    };
  }

  factory FamilyModel.fromMap(Map<String, dynamic> map) {
    return FamilyModel(
      id: map['id'] ?? '',
      next: List<Next>.from(map['next']?.map((x) => Next.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory FamilyModel.fromJson(String source) => FamilyModel.fromMap(json.decode(source));

  @override
  String toString() => 'FamilyModel(id: $id, next: $next)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is FamilyModel &&
      other.id == id &&
      listEquals(other.next, next);
  }

  @override
  int get hashCode => id.hashCode ^ next.hashCode;
}
