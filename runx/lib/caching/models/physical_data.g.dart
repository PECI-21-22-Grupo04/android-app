// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'physical_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PhysicalDataAdapter extends TypeAdapter<PhysicalData> {
  @override
  final int typeId = 8;

  @override
  PhysicalData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PhysicalData(
      dataID: fields[0] as int,
      height: fields[1] as int,
      weight: fields[2] as int,
      bmi: fields[3] as int,
      fitness: fields[4] as String,
      measuredDate: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PhysicalData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.dataID)
      ..writeByte(1)
      ..write(obj.height)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.bmi)
      ..writeByte(4)
      ..write(obj.fitness)
      ..writeByte(5)
      ..write(obj.measuredDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhysicalDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
