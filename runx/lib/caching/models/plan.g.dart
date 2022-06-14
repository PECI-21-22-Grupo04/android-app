// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlanAdapter extends TypeAdapter<Plan> {
  @override
  final int typeId = 4;

  @override
  Plan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Plan(
      planID: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      forPathology: fields[3] as String,
      thumbnailPath: fields[4] as String,
      videoPath: fields[5] as String,
      isPublic: fields[6] as String,
      isShowcase: fields[7] as String,
      creatorID: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Plan obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.planID)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.forPathology)
      ..writeByte(4)
      ..write(obj.thumbnailPath)
      ..writeByte(5)
      ..write(obj.videoPath)
      ..writeByte(6)
      ..write(obj.isPublic)
      ..writeByte(7)
      ..write(obj.isShowcase)
      ..writeByte(8)
      ..write(obj.creatorID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
