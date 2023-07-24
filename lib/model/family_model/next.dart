import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'next.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class Next {
  @HiveField(0)
  String outcome;

  Next({
    required this.outcome,
  });

  // factory Next.fromJson(Map<String, dynamic> json) => _$NextFromJson(json);

  // Map<String, dynamic> toJson() => _$NextToJson(this);

  Next copyWith({
    String? outcome,
  }) {
    return Next(
      outcome: outcome ?? this.outcome,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'outcome': outcome,
    };
  }

  factory Next.fromMap(Map<String, dynamic> map) {
    return Next(
      outcome: map['outcome'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Next.fromJson(String source) => Next.fromMap(json.decode(source));

  @override
  String toString() => 'Next(outcome: $outcome)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Next &&
      other.outcome == outcome;
  }

  @override
  int get hashCode => outcome.hashCode;
}
