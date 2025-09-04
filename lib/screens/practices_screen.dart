import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/student.dart';
import 'practice_session_screen.dart';
import '../services/bluetooth_service.dart';

/**
 * @author Juan De Dios Mendoza Peinado
 * * @abstract
 * Una pantalla que muestra una lista de todos los estudiantes registrados.
 * Permite iniciar una sesión de práctica para cualquier estudiante de la lista.
 * Este widget fue refactorizado y su funcionalidad principal se integró en `StudentsScreen`.
 * * @param bluetoothService La instancia del servicio de Bluetooth, necesaria para pasarla
 * a la pantalla de sesión de práctica.
 * * @package
 */
class PracticesScreen extends StatelessWidget {
  final AppBluetoothService bluetoothService;

  const PracticesScreen({Key? key, required this.bluetoothService}) : super(key: key);

  /**
   * @abstract
   * Construye la interfaz de usuario que muestra la lista de estudiantes.
   * Obtiene los estudiantes de la caja de Hive y los muestra en un ListView.
   * Cada elemento de la lista tiene un botón para iniciar una nueva práctica.
   * * @return Un widget Scaffold con la lista de estudiantes.
   */
  @override
  Widget build(BuildContext context) {
    final studentsBox = Hive.box<Student>('students');
    final students = studentsBox.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prácticas'),
        backgroundColor: const Color(0xFF2C3E50),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text('${student.firstName} ${student.lastName}'),
              trailing: IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.green),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PracticeSessionScreen(
                        student: student,
                        studentIndex: index,
                        bluetoothService: bluetoothService,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}