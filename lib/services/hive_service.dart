import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/student.dart';

class HiveService {
  // Inicialización de Hive y apertura de la box
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(StudentAdapter());
    await Hive.openBox<Student>('students');
  }

  // Obtener la box de estudiantes
  static Box<Student> _getStudentsBox() {
    return Hive.box<Student>('students');
  }

  // Añadir un nuevo estudiante
  static Future<void> addStudent(Student student) async {
    final box = _getStudentsBox();
    await box.add(student);
  }

  // Actualizar un estudiante existente
  static Future<void> updateStudent(int index, Student student) async {
    final box = _getStudentsBox();
    await box.putAt(index, student);
  }

  // Eliminar un estudiante
  static Future<void> deleteStudent(int index) async {
    final box = _getStudentsBox();
    await box.deleteAt(index);
  }

  // Obtener todos los estudiantes
  static List<Student> getAllStudents() {
    final box = _getStudentsBox();
    return box.values.toList();
  }

  // Obtener un estudiante por índice
  static Student? getStudent(int index) {
    final box = _getStudentsBox();
    return box.getAt(index);
  }

  // Contar el número total de estudiantes
  static int getStudentCount() {
    return _getStudentsBox().length;
  }

  // Cerrar la box cuando ya no se necesite (opcional)
  static Future<void> closeBox() async {
    await _getStudentsBox().close();
  }

  // Limpiar todos los estudiantes (para desarrollo/debug)
  static Future<void> clearAllStudents() async {
    await _getStudentsBox().clear();
  }
}