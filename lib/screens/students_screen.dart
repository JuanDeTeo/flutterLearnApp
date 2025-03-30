import 'package:flutter/material.dart';
import 'add_edit_student.dart';
import 'student_detail.dart';
import '../models/student.dart';
import '../services/hive_service.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({Key? key}) : super(key: key);

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() {
    setState(() {
      students = HiveService.getAllStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Alumnos'),
        backgroundColor: const Color(0xFF2C3E50),
      ),
      body: students.isEmpty
          ? const Center(child: Text('No hay alumnos registrados'))
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text('${student.firstName} ${student.lastName}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteStudent(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editStudent(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.info, color: Colors.green),
                          onPressed: () => _viewDetails(student),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF2C94C),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () => _addNewStudent(),
      ),
    );
  }

  void _addNewStudent() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditStudent()),
    );
    _loadStudents();
  }

  void _editStudent(int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditStudent(
          student: students[index],
          index: index,
        ),
      ),
    );
    _loadStudents();
  }

  void _viewDetails(Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDetail(student: student),
      ),
    );
  }

  void _deleteStudent(int index) async {
    await HiveService.deleteStudent(index);
    _loadStudents();
  }
}