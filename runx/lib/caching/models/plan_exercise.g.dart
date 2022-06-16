// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_exercise.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlanExerciseAdapter extends TypeAdapter<PlanExercise> {
  @override
  final int typeId = 5;

  @override
  PlanExercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlanExercise(
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
      includedDate: fields[11] as String,
      numSets: fields[12] as String,
      numReps: fields[13] as String,
      durationTime: fields[14] as String,
      exerciseOrder: fields[15] as String,
      belongsToProgramID: fields[16] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PlanExercise obj) {
    writer
      ..writeByte(17)
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
      ..write(obj.creatorID)
      ..writeByte(11)
      ..write(obj.includedDate)
      ..writeByte(12)
      ..write(obj.numSets)
      ..writeByte(13)
      ..write(obj.numReps)
      ..writeByte(14)
      ..write(obj.durationTime)
      ..writeByte(15)
      ..write(obj.exerciseOrder)
      ..writeByte(16)
      ..write(obj.belongsToProgramID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
