import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/student.dart';
import 'add_edit_student.dart';
import 'student_detail.dart';
import 'practice_session_screen.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({Key? key}) : super(key: key);

  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Alumnos'),
        backgroundColor: const Color(0xFF2C3E50),
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
                            ? Text(
                                'Prácticas: ${student.practices.length}',
                                style: const TextStyle(fontSize: 12),
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Botón para prácticas (ahora con icono diferente)
                            IconButton(
                              icon: const Icon(Icons.assignment, color: Color(0xFF708238)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PracticeSessionScreen(
                                      student: student,
                                      studentIndex: index,
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Botón de editar
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddEditStudent(
                                      student: student,
                                      index: index,
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Botón de eliminar
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await _deleteStudent(context, index);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentDetail(
                                student: student,
                                studentIndex: index,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF2C94C),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditStudent(),
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteStudent(BuildContext context, int index) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de eliminar este alumno?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final box = Hive.box<Student>('students');
      await box.deleteAt(index);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alumno eliminado')),
      );
    }
  }
}