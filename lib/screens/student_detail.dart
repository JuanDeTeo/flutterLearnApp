import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/student.dart';

class StudentDetail extends StatelessWidget {
  final Student student;

  const StudentDetail({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${student.firstName} ${student.lastName}'),
        backgroundColor: const Color(0xFF2C3E50),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Nombre', student.firstName),
            _buildDetailRow('Apellido Paterno', student.lastName),
            _buildDetailRow('Apellido Materno', student.motherLastName),
            _buildDetailRow(
              'Fecha de Nacimiento', 
              DateFormat('dd/MM/yyyy').format(student.birthDate),
            ),
            _buildDetailRow('Institución', student.institution),
          ],
        ),
      ),
    );
  }

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
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
          const Divider(),
        ],
      ),
    );
  }
}