// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_workout.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryWorkoutAdapter extends TypeAdapter<HistoryWorkout> {
  @override
  final int typeId = 7;

  @override
  HistoryWorkout read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryWorkout(
      logID: fields[0] as String,
      pName: fields[1] as String,
      timeTaken: fields[2] as String,
      heartRate: fields[3] as String,
      caloriesBurnt: fields[4] as String,
      doneDate: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryWorkout obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.logID)
      ..writeByte(1)
      ..write(obj.pName)
      ..writeByte(2)
      ..write(obj.timeTaken)
      ..writeByte(3)
      ..write(obj.heartRate)
      ..writeByte(4)
      ..write(obj.caloriesBurnt)
      ..writeByte(5)
      ..write(obj.doneDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryWorkoutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
