// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      uid: fields[0] as String,
      username: fields[1] as String,
      avatar: fields[2] as AvatarModel,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.avatar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AvatarModelAdapter extends TypeAdapter<AvatarModel> {
  @override
  final int typeId = 1;

  @override
  AvatarModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AvatarModel(
      backgroundColorValue: fields[0] as int,
      textColorValue: fields[1] as int,
      initials: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AvatarModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.backgroundColorValue)
      ..writeByte(1)
      ..write(obj.textColorValue)
      ..writeByte(2)
      ..write(obj.initials);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvatarModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
