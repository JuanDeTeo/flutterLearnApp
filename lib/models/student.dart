import 'package:hive/hive.dart';

part 'student.g.dart';

@HiveType(typeId: 0)
class Student {
  @HiveField(0)
  final String firstName;
  
  @HiveField(1)
  final String lastName;
  
  @HiveField(2)
  final String motherLastName;
  
  @HiveField(3)
  final DateTime birthDate;
  
  @HiveField(4)
  final String institution;

  @HiveField(5, defaultValue: []) // ¡Esto es importante!
  final List<PracticeResult> practices;

  Student({
    required this.firstName,
    required this.lastName,
    required this.motherLastName,
    required this.birthDate,
    required this.institution,
    this.practices = const [], // Valor por defecto
  });
}

@HiveType(typeId: 1)
class PracticeResult {
  @HiveField(0)
  final int practiceNumber;
  
  @HiveField(1)
  final DateTime date;
  
  @HiveField(2)
  final String results;
  
  @HiveField(3)
  final String score;

  PracticeResult({
    required this.practiceNumber,
    required this.date,
    required this.results,
    required this.score,
  });
}