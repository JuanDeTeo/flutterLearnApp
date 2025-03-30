import 'package:hive/hive.dart';

part 'student.g.dart'; // Archivo que será generado automáticamente

@HiveType(typeId: 0) // Identificador único para este tipo de dato en Hive
class Student {
  @HiveField(0) // Cada campo necesita un ID único
  final String firstName; // Nombre del alumno
  
  @HiveField(1)
  final String lastName; // Apellido paterno
  
  @HiveField(2)
  final String motherLastName; // Apellido materno
  
  @HiveField(3)
  final DateTime birthDate; // Fecha de nacimiento
  
  @HiveField(4)
  final String institution; // Institución educativa

  // Constructor requerido
  Student({
    required this.firstName,
    required this.lastName,
    required this.motherLastName,
    required this.birthDate,
    required this.institution,
  });
}