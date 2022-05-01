// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructor_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InstructorProfileAdapter extends TypeAdapter<InstructorProfile> {
  @override
  final int typeId = 1;

  @override
  InstructorProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InstructorProfile(
      email: fields[0] as String,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      birthdate: fields[3] as String,
      sex: fields[4] as String,
      country: fields[5] as String,
      registerDate: fields[6] as String,
      maxClients: fields[7] as String,
      currentClients: fields[8] as String,
      averageRating: fields[9] as String,
      reviews: (fields[10] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, InstructorProfile obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.birthdate)
      ..writeByte(4)
      ..write(obj.sex)
      ..writeByte(5)
      ..write(obj.country)
      ..writeByte(6)
      ..write(obj.registerDate)
      ..writeByte(7)
      ..write(obj.maxClients)
      ..writeByte(8)
      ..write(obj.currentClients)
      ..writeByte(9)
      ..write(obj.averageRating)
      ..writeByte(10)
      ..write(obj.reviews);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstructorProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
