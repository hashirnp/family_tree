// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_name_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FamilyNameModelAdapter extends TypeAdapter<FamilyNameModel> {
  @override
  final int typeId = 0;

  @override
  FamilyNameModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FamilyNameModel(
      id: fields[0] as String,
      familyName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FamilyNameModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.familyName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FamilyNameModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
