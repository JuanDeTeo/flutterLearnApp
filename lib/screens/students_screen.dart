import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/bluetooth_service.dart';
import '../models/student.dart';
import 'add_edit_student.dart';
import 'student_detail.dart';
import 'practice_session_screen.dart';
import 'bluetooth_screen.dart';

/**
 * @author Juan De Dios Mendoza Peinado
 * * @abstract
 * Pantalla principal de la pestaña "Alumnos". Muestra una lista de todos los estudiantes
 * registrados y proporciona opciones para ver detalles, editar, eliminar e iniciar 
 * una sesión de práctica para cada uno.
 * * @param bluetoothService La instancia compartida del servicio Bluetooth.
 */
class StudentsScreen extends StatefulWidget {
  final AppBluetoothService bluetoothService;
  
  const StudentsScreen({Key? key, required this.bluetoothService}) : super(key: key);

  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

/**
 * @abstract
 * Gestiona el estado de la pantalla de alumnos.
 */
class _StudentsScreenState extends State<StudentsScreen> {
  
  /**
   * @abstract
   * Construye la interfaz de usuario de la pantalla. Utiliza un [ValueListenableBuilder]
   * para reaccionar a los cambios en la base de datos de Hive y mantener la lista de
   * alumnos siempre actualizada.
   * * @return Un widget Scaffold que contiene la lista de alumnos y acciones.
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Alumnos'),
        backgroundColor: const Color(0xFF2C3E50),
        actions: [
          StreamBuilder<dynamic>(
            stream: widget.bluetoothService.connectionStream,
            builder: (context, snapshot) {
              return IconButton(
                icon: Icon(
                  snapshot.data != null ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                  color: snapshot.data != null ? Colors.lightBlueAccent : Colors.white,
                ),
                onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BluetoothScreen(bluetoothService: widget.bluetoothService),
                    ),
                  );
                },
              );
            }
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Student>('students').listenable(),
        builder: (context, Box<Student> box, _) {
          final students = box.values.toList();
          
          return students.isEmpty
              ? const Center(child: Text('No hay alumnos registrados'))
              : ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        title: Text('${student.firstName} ${student.lastName}'),
                        subtitle: student.practices.isNotEmpty
                            ? Text('Prácticas: ${student.practices.length}')
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.assignment, color: Color(0xFF708238)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PracticeSessionScreen(
                                      student: student,
                                      studentIndex: index,
                                      bluetoothService: widget.bluetoothService,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditStudent(student: student, index: index))),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteStudent(context, index),
                            ),
                          ],
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StudentDetail(student: student, studentIndex: index))),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF2C94C),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEditStudent())),
      ),
    );
  }

  /**
   * @abstract
   * Muestra un diálogo de confirmación y, si el usuario confirma, elimina un 
   * estudiante de la base de datos de Hive.
   * * @param context El BuildContext para mostrar el diálogo.
   * @param index El índice del estudiante a eliminar en la caja de Hive.
   */
  Future<void> _deleteStudent(BuildContext context, int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de eliminar este alumno?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed == true) {
      await Hive.box<Student>('students').deleteAt(index);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alumno eliminado')));
      }
    }
  }
}