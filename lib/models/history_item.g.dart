// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryItemAdapter extends TypeAdapter<HistoryItem> {
  @override
  final int typeId = 0;

  @override
  HistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryItem(
      originalPrompt: fields[0] as String,
      enhancedPrompt: fields[1] as String,
      date: fields[2] as DateTime,
      tone: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.originalPrompt)
      ..writeByte(1)
      ..write(obj.enhancedPrompt)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.tone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
