// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseAdapter extends TypeAdapter<Exercise> {
  @override
  final int typeId = 3;

  @override
  Exercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Exercise(
      exerciseID: fields[0] as String,
      name: fields[1] as String,
      forPathology: fields[2] as String,
      difficulty: fields[3] as String,
      description: fields[4] as String,
      targetMuscle: fields[5] as String,
      thumbnailPath: fields[6] as String,
      videoPath: fields[7] as String,
      isPublic: fields[8] as String,
      firebaseRef: fields[9] as String,
      creatorID: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Exercise obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.exerciseID)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.forPathology)
      ..writeByte(3)
      ..write(obj.difficulty)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.targetMuscle)
      ..writeByte(6)
      ..write(obj.thumbnailPath)
      ..writeByte(7)
      ..write(obj.videoPath)
      ..writeByte(8)
      ..write(obj.isPublic)
      ..writeByte(9)
      ..write(obj.firebaseRef)
      ..writeByte(11)
      ..write(obj.creatorID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
