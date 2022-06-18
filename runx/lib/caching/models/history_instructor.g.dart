// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_instructor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryInstructorAdapter extends TypeAdapter<HistoryInstructor> {
  @override
  final int typeId = 6;

  @override
  HistoryInstructor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryInstructor(
      email: fields[0] as String,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      signedDate: fields[3] as String,
      canceledDate: fields[4] as String,
      rating: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryInstructor obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.signedDate)
      ..writeByte(4)
      ..write(obj.canceledDate)
      ..writeByte(5)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryInstructorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
