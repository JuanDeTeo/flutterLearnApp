import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/student.dart';

/**
 * @author Juan De Dios Mendoza Peinado
 */

/**
 * @abstract Provee una capa de abstracción para interactuar con la base de datos local Hive.
 * @package services
 * @access public
 * * @class HiveService
 * @abstract Contiene métodos estáticos para realizar operaciones CRUD (Crear, Leer, Actualizar, Eliminar)
 * en una "caja" (box) de Hive que almacena objetos de tipo `Student`.
 */
class HiveService {
  /**
   * @abstract Inicializa Hive y abre la caja de estudiantes.
   * @return Future<void>
   * @access public
   * @description Este método debe ser llamado al inicio de la aplicación para
   * asegurar que Hive esté configurado antes de cualquier operación.
   */
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(StudentAdapter());
    await Hive.openBox<Student>('students');
  }

  /**
   * @abstract Obtiene la instancia de la caja de estudiantes.
   * @return Box<Student> La caja que contiene los objetos `Student`.
   * @access private
   */
  static Box<Student> _getStudentsBox() {
    return Hive.box<Student>('students');
  }

  /**
   * @abstract Añade un nuevo estudiante a la caja.
   * @param student El objeto `Student` a ser añadido.
   * @return Future<void>
   * @access public
   */
  static Future<void> addStudent(Student student) async {
    final box = _getStudentsBox();
    await box.add(student);
  }

  /**
   * @abstract Actualiza un estudiante existente en la caja en un índice específico.
   * @param index El índice del estudiante a actualizar.
   * @param student El nuevo objeto `Student` que reemplazará al antiguo.
   * @return Future<void>
   * @access public
   */
  static Future<void> updateStudent(int index, Student student) async {
    final box = _getStudentsBox();
    await box.putAt(index, student);
  }

  /**
   * @abstract Elimina un estudiante de la caja en un índice específico.
   * @param index El índice del estudiante a eliminar.
   * @return Future<void>
   * @access public
   */
  static Future<void> deleteStudent(int index) async {
    final box = _getStudentsBox();
    await box.deleteAt(index);
  }

  /**
   * @abstract Obtiene una lista de todos los estudiantes almacenados en la caja.
   * @return List<Student> Una lista con todos los estudiantes.
   * @access public
   */
  static List<Student> getAllStudents() {
    final box = _getStudentsBox();
    return box.values.toList();
  }

  /**
   * @abstract Obtiene un estudiante por su índice en la caja.
   * @param index El índice del estudiante a obtener.
   * @return Student? El objeto `Student` en el índice dado, o `null` si no existe.
   * @access public
   */
  static Student? getStudent(int index) {
    final box = _getStudentsBox();
    return box.getAt(index);
  }

  /**
   * @abstract Cuenta el número total de estudiantes en la caja.
   * @return int El número de estudiantes.
   * @access public
   * @ignore No es escencial pero es de utilidad
   */
  static int getStudentCount() {
    return _getStudentsBox().length;
  }

  /**
   * @abstract Cierra la caja de estudiantes.
   * @return Future<void>
   * @access public
   * @ignore Opcional, útil para liberar recursos si la caja no se usará más.
   */
  static Future<void> closeBox() async {
    await _getStudentsBox().close();
  }

  /**
   * @abstract Limpia todos los datos de la caja de estudiantes.
   * @return Future<void>
   * @access public
   * @ignore Usar con precaución, principalmente para desarrollo y depuración.
   */
  static Future<void> clearAllStudents() async {
    await _getStudentsBox().clear();
  }
}