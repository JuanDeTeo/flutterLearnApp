import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../models/student.dart';

/**
 * @author Juan De Dios Mendoza Peinado
 * * @abstract
 * Una pantalla que muestra los detalles completos de un estudiante específico,
 * incluyendo su información personal y un historial de todas sus prácticas realizadas.
 * * @param student El objeto del estudiante cuyos detalles se mostrarán.
 * @param studentIndex El índice del estudiante en la base de datos de Hive para escuchar actualizaciones.
 */
class StudentDetail extends StatefulWidget {
  final Student student;
  final int studentIndex;

  const StudentDetail({
    Key? key,
    required this.student,
    required this.studentIndex,
  }) : super(key: key);

  @override
  State<StudentDetail> createState() => _StudentDetailState();
}

/**
 * @abstract
 * El estado de la pantalla [StudentDetail].
 * Utiliza un [ValueListenableBuilder] para reconstruir la UI automáticamente si los datos
 * del estudiante cambian en la base de datos de Hive.
 */
class _StudentDetailState extends State<StudentDetail> {
  /**
   * @abstract
   * Construye la interfaz de usuario de la pantalla de detalles del alumno.
   * Escucha cambios en la caja de 'students' de Hive y actualiza la vista
   * si el alumno actual es modificado.
   * * @return Un widget Scaffold con los detalles y el historial de prácticas del alumno.
   */
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Student>('students').listenable(),
      builder: (context, Box<Student> box, _) {
        final updatedStudent = box.getAt(widget.studentIndex);
        if (updatedStudent == null) {
          return const Scaffold(
            body: Center(child: Text('Alumno no encontrado'))
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('${updatedStudent.firstName} ${updatedStudent.lastName}'),
            backgroundColor: const Color(0xFF2C3E50),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Nombre', updatedStudent.firstName),
                _buildDetailRow('Apellido Paterno', updatedStudent.lastName),
                _buildDetailRow('Apellido Materno', updatedStudent.motherLastName),
                _buildDetailRow(
                  'Fecha de Nacimiento', 
                  DateFormat('dd/MM/yyyy').format(updatedStudent.birthDate),
                ),
                _buildDetailRow('Institución', updatedStudent.institution),
                const SizedBox(height: 25),
                const Divider(),
                const Text(
                  'Historial de Prácticas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 10),
                if (updatedStudent.practices.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: Text(
                        'No hay prácticas registradas',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  )
                else
                  Column(
                    children: updatedStudent.practices.reversed.map((practice) {
                      return _buildPracticeCard(practice);
                    }).toList(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /**
   * @abstract
   * Widget auxiliar para construir una fila de detalle con una etiqueta y un valor.
   * * @param label El texto de la etiqueta (ej. "Nombre").
   * @param value El valor a mostrar (ej. "Juan").
   * @return Un widget Column que muestra la etiqueta y el valor.
   */
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
          const Divider(),
        ],
      ),
    );
  }

  /**
   * @abstract
   * Widget auxiliar para construir una tarjeta que resume una sesión de práctica.
   * * @param practice El objeto [PracticeResult] que contiene los datos de la práctica.
   * @return Un widget Card estilizado con los detalles de la práctica.
   */
  Widget _buildPracticeCard(PracticeResult practice) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Práctica ${practice.practiceNumber}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getScoreColor(practice.score),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    practice.score,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Fecha: ${DateFormat('dd/MM/yyyy - HH:mm').format(practice.date)}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: practice.results.split(',').map((result) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: result == '✓' ? Colors.green[100] : Colors.red[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      result,
                      style: TextStyle(
                        color: result == '✓' ? Colors.green : Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /**
   * @abstract
   * Determina el color de fondo para el indicador de puntuación basado en el rendimiento.
   * * @param score La puntuación en formato "correctas/totales" (ej. "8/10").
   * @return Un [Color] (verde, amarillo o rojo) según el porcentaje de aciertos.
   */
  Color _getScoreColor(String score) {
    final parts = score.split('/');
    if (parts.length == 2) {
      final correct = int.tryParse(parts[0]) ?? 0;
      final total = int.tryParse(parts[1]) ?? 1;
      final ratio = total == 0 ? 0 : correct / total;
      
      if (ratio >= 0.8) return Colors.green;
      if (ratio >= 0.5) return const Color(0xFFF2C94C);
      return Colors.red;
    }
    return const Color(0xFF2C3E50);
  }
}