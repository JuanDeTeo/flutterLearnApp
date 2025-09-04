import 'package:hive/hive.dart';

part 'student.g.dart';

/**
 * @author Juan De Dios Mendoza Peinado
 * * @abstract
 * Define el modelo de datos para un estudiante. Esta clase es un tipo de Hive,
 * lo que permite que sus instancias sean almacenadas y recuperadas de la
 * base de datos local.
 * * @package
 *///
@HiveType(typeId: 0)
class Student {
  /**
   * @var firstName El nombre del estudiante.
   */
  @HiveField(0)
  final String firstName;
  
  /**
   * @var lastName El apellido paterno del estudiante.
   */
  @HiveField(1)
  final String lastName;
  
  /**
   * @var motherLastName El apellido materno del estudiante.
   */
  @HiveField(2)
  final String motherLastName;
  
  /**
   * @var birthDate La fecha de nacimiento del estudiante.
   */
  @HiveField(3)
  final DateTime birthDate;
  
  /**
   * @var institution La institución a la que pertenece el estudiante.
   */
  @HiveField(4)
  final String institution;

  /**
   * @var practices Una lista que contiene el historial de todas las prácticas
   * realizadas por el estudiante. Se inicializa como una lista vacía por defecto.
   */
  @HiveField(5, defaultValue: [])
  final List<PracticeResult> practices;

  /**
   * @abstract
   * Constructor para crear una nueva instancia de [Student].
   * * @param firstName El nombre del estudiante.
   * @param lastName El apellido paterno del estudiante.
   * @param motherLastName El apellido materno del estudiante.
   * @param birthDate La fecha de nacimiento del estudiante.
   * @param institution La institución del estudiante.
   * @param practices La lista de resultados de prácticas; opcional.
   */
  Student({
    required this.firstName,
    required this.lastName,
    required this.motherLastName,
    required this.birthDate,
    required this.institution,
    this.practices = const [],
  });
}

/**
 * @abstract
 * Define el modelo de datos para el resultado de una práctica.
 * Almacena los detalles de una sesión de práctica específica, incluyendo
 * la fecha, los resultados y la puntuación. Es un tipo de Hive para ser
 * almacenado dentro de la lista de prácticas del [Student].
 * * @package
 */
@HiveType(typeId: 1)
class PracticeResult {
  /**
   * @var practiceNumber El número secuencial que identifica la práctica.
   */
  @HiveField(0)
  final int practiceNumber;
  
  /**
   * @var date La fecha y hora en que se completó la práctica.
   */
  @HiveField(1)
  final DateTime date;
  
  /**
   * @var results Una cadena que representa los resultados detallados,
   * usualmente una secuencia de aciertos y errores (ej. "✓,✗,✓").
   */
  @HiveField(2)
  final String results;
  
  /**
   * @var score La puntuación final de la práctica en formato "aciertos/total" (ej. "8/10").
   */
  @HiveField(3)
  final String score;

  /**
   * @abstract
   * Constructor para crear una nueva instancia de [PracticeResult].
   * * @param practiceNumber El número de la práctica.
   * @param date La fecha de la práctica.
   * @param results La cadena con los resultados detallados.
   * @param score La puntuación final.
   */
  PracticeResult({
    required this.practiceNumber,
    required this.date,
    required this.results,
    required this.score,
  });
}