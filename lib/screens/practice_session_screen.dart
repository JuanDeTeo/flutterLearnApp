import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../models/student.dart';

class PracticeSessionScreen extends StatefulWidget {
  final Student student;
  final int studentIndex;

  const PracticeSessionScreen({
    Key? key,
    required this.student,
    required this.studentIndex,
  }) : super(key: key);

  @override
  _PracticeSessionScreenState createState() => _PracticeSessionScreenState();
}

class _PracticeSessionScreenState extends State<PracticeSessionScreen> {
  final TextEditingController _inputController = TextEditingController();
  List<String> practiceItems = [];
  List<String?> userResults = [];
  bool isPracticing = false;
  bool showResults = false;
  int currentItemIndex = 0;
  int correctAnswers = 0;
  late int nextPracticeNumber;

  @override
  void initState() {
    super.initState();
    nextPracticeNumber = widget.student.practices.isEmpty 
        ? 1 
        : widget.student.practices.last.practiceNumber + 1;
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _startPractice() {
    if (_inputController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese al menos un carácter')),
      );
      return;
    }

    setState(() {
      practiceItems = _inputController.text.split(',').expand((item) {
        return item.trim().split('');
      }).where((char) => char.isNotEmpty).toList();
      
      userResults = List.filled(practiceItems.length, null);
      isPracticing = true;
      currentItemIndex = 0;
      correctAnswers = 0;
      showResults = false;
    });
  }

  void _recordResult(bool isCorrect) {
    setState(() {
      userResults[currentItemIndex] = isCorrect ? '✓' : '✗';
      if (isCorrect) correctAnswers++;
      
      if (currentItemIndex < practiceItems.length - 1) {
        currentItemIndex++;
      } else {
        _finishPractice();
      }
    });
  }

  Future<void> _finishPractice() async {
    final score = '$correctAnswers/${practiceItems.length}';
    final results = userResults.join(',');

    final practiceResult = PracticeResult(
      practiceNumber: nextPracticeNumber,
      date: DateTime.now(),
      results: results,
      score: score,
    );

    final studentsBox = Hive.box<Student>('students');
    final updatedStudent = Student(
      firstName: widget.student.firstName,
      lastName: widget.student.lastName,
      motherLastName: widget.student.motherLastName,
      birthDate: widget.student.birthDate,
      institution: widget.student.institution,
      practices: [...widget.student.practices, practiceResult],
    );

    await studentsBox.putAt(widget.studentIndex, updatedStudent);
    
    setState(() {
      showResults = true;
    });
  }

  void _restartPractice() {
    setState(() {
      isPracticing = false;
      showResults = false;
      practiceItems = [];
      userResults = [];
      nextPracticeNumber++;
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Práctica $nextPracticeNumber'),
        backgroundColor: const Color(0xFF2C3E50),
      ),
      body: showResults
          ? _buildResultsScreen()
          : (isPracticing ? _buildPracticeSession() : _buildPracticeSetup()),
    );
  }

  Widget _buildPracticeSetup() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Ingrese caracteres o palabras separados por comas:',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _inputController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ejemplo: a,b,hola,1',
              hintText: 'Cada elemento será desglosado en letras',
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF708238),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar', style: TextStyle(fontSize: 16)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2C94C),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                ),
                onPressed: _startPractice,
                child: const Text('Iniciar Práctica', 
                    style: TextStyle(fontSize: 16, color: Colors.black)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeSession() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                key: ValueKey(currentItemIndex),
                practiceItems[currentItemIndex],
                style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.check, size: 30),
              label: const Text('Correcto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onPressed: () => _recordResult(true),
            ),
            const SizedBox(width: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.close, size: 30),
              label: const Text('Incorrecto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onPressed: () => _recordResult(false),
            ),
          ],
        ),
        const SizedBox(height: 20),
        LinearProgressIndicator(
          value: (currentItemIndex + 1) / practiceItems.length,
          backgroundColor: Colors.grey[200],
          color: const Color(0xFF2C3E50),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${currentItemIndex + 1}/${practiceItems.length}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsScreen() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            correctAnswers / practiceItems.length >= 0.7 
                ? Icons.check_circle 
                : Icons.warning,
            size: 80,
            color: correctAnswers / practiceItems.length >= 0.7 
                ? Colors.green 
                : Colors.orange,
          ),
          const SizedBox(height: 30),
          Text(
            'Práctica Completada',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            'Resultado: $correctAnswers/${practiceItems.length}',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C3E50),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                ),
                onPressed: _restartPractice,
                child: const Text('Repetir Práctica', style: TextStyle(fontSize: 16)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2C94C),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver', style: TextStyle(fontSize: 16, color: Colors.black)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}