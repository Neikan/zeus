// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'constants.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceTypeAdapter extends TypeAdapter<ServiceType> {
  @override
  final int typeId = 2;

  @override
  ServiceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ServiceType.filejoker;
      case 1:
        return ServiceType.novafile;
      default:
        return ServiceType.filejoker;
    }
  }

  @override
  void write(BinaryWriter writer, ServiceType obj) {
    switch (obj) {
      case ServiceType.filejoker:
        writer.writeByte(0);
        break;
      case ServiceType.novafile:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
