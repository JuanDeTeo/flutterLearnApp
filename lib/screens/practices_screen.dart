import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/student.dart';
import 'practice_session_screen.dart';
import '../services/bluetooth_service.dart';

// 1. Se convierte en un StatelessWidget, ya que no necesita gestionar el estado del servicio.
class PracticesScreen extends StatelessWidget {
  // 2. Recibe la instancia del servicio compartida.
  final AppBluetoothService bluetoothService;

  const PracticesScreen({Key? key, required this.bluetoothService}) : super(key: key);

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
                        // 3. Se pasa la instancia del servicio que se recibió.
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
