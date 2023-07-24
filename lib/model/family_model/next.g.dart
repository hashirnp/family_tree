// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_element

part of 'next.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NextAdapter extends TypeAdapter<Next> {
  @override
  final int typeId = 2;

  @override
  Next read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Next(
      outcome: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Next obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.outcome);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NextAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************


Map<String, dynamic> _$NextToJson(Next instance) => <String, dynamic>{
      'outcome': instance.outcome,
    };
