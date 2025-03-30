// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentAdapter extends TypeAdapter<Student> {
  @override
  final int typeId = 0;

  @override
  Student read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Student(
      firstName: fields[0] as String,
      lastName: fields[1] as String,
      motherLastName: fields[2] as String,
      birthDate: fields[3] as DateTime,
      institution: fields[4] as String,
      practices:
          fields[5] == null ? [] : (fields[5] as List).cast<PracticeResult>(),
    );
  }

  @override
  void write(BinaryWriter writer, Student obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.motherLastName)
      ..writeByte(3)
      ..write(obj.birthDate)
      ..writeByte(4)
      ..write(obj.institution)
      ..writeByte(5)
      ..write(obj.practices);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PracticeResultAdapter extends TypeAdapter<PracticeResult> {
  @override
  final int typeId = 1;

  @override
  PracticeResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PracticeResult(
      practiceNumber: fields[0] as int,
      date: fields[1] as DateTime,
      results: fields[2] as String,
      score: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PracticeResult obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.practiceNumber)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.results)
      ..writeByte(3)
      ..write(obj.score);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PracticeResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
