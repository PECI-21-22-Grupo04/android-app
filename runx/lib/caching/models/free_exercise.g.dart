// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'free_exercise.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FreeExerciseAdapter extends TypeAdapter<FreeExercise> {
  @override
  final int typeId = 3;

  @override
  FreeExercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FreeExercise(
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
      creatorID: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FreeExercise obj) {
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
      ..writeByte(10)
      ..write(obj.creatorID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FreeExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
