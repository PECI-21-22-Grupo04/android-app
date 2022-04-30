// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      email: fields[0] as String,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      birthdate: fields[3] as String,
      sex: fields[4] as String,
      street: fields[5] as String,
      postCode: fields[6] as String,
      city: fields[7] as String,
      country: fields[8] as String,
      pathologies: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.street)
      ..writeByte(6)
      ..write(obj.postCode)
      ..writeByte(7)
      ..write(obj.city)
      ..writeByte(8)
      ..write(obj.country)
      ..writeByte(9)
      ..write(obj.pathologies);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
