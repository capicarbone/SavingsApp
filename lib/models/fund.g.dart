// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fund.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FundAdapter extends TypeAdapter<Fund> {
  @override
  final int typeId = 3;

  @override
  Fund read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Fund(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      maximumLimit: fields[4] as double,
      minimumLimit: fields[3] as double,
      percetageAssignment: fields[5] as double,
      balance: fields[6] as double,
      categories: (fields[7] as List)?.cast<Category>(),
    );
  }

  @override
  void write(BinaryWriter writer, Fund obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.minimumLimit)
      ..writeByte(4)
      ..write(obj.maximumLimit)
      ..writeByte(5)
      ..write(obj.percetageAssignment)
      ..writeByte(6)
      ..write(obj.balance)
      ..writeByte(7)
      ..write(obj.categories);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FundAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
