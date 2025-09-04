import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../models/student.dart';
import '../../services/bluetooth_service.dart';

/**
 * @author Juan De Dios Mendoza Peinado
 * * @abstract
 * Clase auxiliar para filtrar entradas de Bluetooth repetidas (key bounce).
 * Procesa un carácter y luego entra en un período de "enfriamiento"
 * durante el cual ignora el mismo carácter para evitar registros múltiples.
 *
 * @param coolDown La duración del período de enfriamiento.
 */
class InputThrottle {
  final Duration coolDown;
  /**
   * @var _lastProcessedTime Mapa para almacenar la última vez que se procesó cada carácter.
   */
  final Map<String, DateTime> _lastProcessedTime = {};

  InputThrottle({required this.coolDown});

  /**
   * @abstract
   * Determina si un carácter debe ser procesado.
   * * @param char El carácter recibido de la entrada.
   * @return `true` si el carácter es nuevo o si su período de enfriamiento ha terminado.
   */
  bool canProcess(String char) {
    if (char.isEmpty) return false;

    final charKey = char[0]; // Usamos solo el primer carácter de la entrada
    final now = DateTime.now();
    final lastTime = _lastProcessedTime[charKey];

    if (lastTime == null || now.difference(lastTime) > coolDown) {
      _lastProcessedTime[charKey] = now;
      return true;
    }
    
    return false;
  }
}

/**
 * @abstract
 * Pantalla donde se lleva a cabo la sesión de práctica de Braille.
 * El alumno visualiza caracteres y responde, y la app registra sus aciertos y errores.
 * * @param student El alumno que está realizando la práctica.
 * @param studentIndex El índice del alumno en la base de datos de Hive.
 * @param bluetoothService La instancia del servicio de Bluetooth para recibir las respuestas.
 */
class PracticeSessionScreen extends StatefulWidget {
  final Student student;
  final int studentIndex;
  final AppBluetoothService bluetoothService;

  const PracticeSessionScreen({
    Key? key,
    required this.student,
    required this.studentIndex,
    required this.bluetoothService,
  }) : super(key: key);

  @override
  _PracticeSessionScreenState createState() => _PracticeSessionScreenState();
}

class _PracticeSessionScreenState extends State<PracticeSessionScreen> {
  /**
   * @var _inputThrottle Instancia para regular las entradas de Bluetooth.
   */
  final _inputThrottle = InputThrottle(coolDown: const Duration(milliseconds: 500));

  final TextEditingController _inputController = TextEditingController();
  List<String> practiceItems = [];
  List<String?> userResults = [];
  bool isPracticing = false;
  bool showResults = false;
  int currentItemIndex = 0;
  int correctAnswers = 0;
  late int nextPracticeNumber;

  StreamSubscription<String>? _dataSubscription;

  @override
  void initState() {
    super.initState();
    nextPracticeNumber = widget.student.practices.isEmpty
        ? 1
        : widget.student.practices.last.practiceNumber + 1;

    _listenToBluetoothData();
  }

  /**
   * @abstract
   * Se suscribe al flujo de datos del servicio de Bluetooth.
   * Cuando se reciben datos, los procesa a través del _inputThrottle para evitar
   * registros duplicados y llama a _recordResult.
   */
  void _listenToBluetoothData() {
    _dataSubscription = widget.bluetoothService.dataStream.listen((data) {
      if (isPracticing && !showResults) {
        final receivedFullString = data.trim().toUpperCase();
        if (receivedFullString.isEmpty) return;

        final charToProcess = receivedFullString[0];

        if (_inputThrottle.canProcess(charToProcess)) {
          final expectedChar = practiceItems[currentItemIndex].toUpperCase();
          _recordResult(expectedChar == charToProcess);
        }
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _dataSubscription?.cancel();
    super.dispose();
  }

  /**
   * @abstract
   * Inicia la sesión de práctica.
   * Toma los caracteres del _inputController, los separa y prepara el estado
   * de la pantalla para comenzar la sesión.
   */
  void _startPractice() {
    // Expresión regular para aceptar solo letras, incluyendo vocales con acento y la 'ñ'.
    final RegExp allowedChars = RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ]');
    
    // Extrae todos los caracteres que coinciden con la expresión regular.
    final List<String> filteredItems = allowedChars
        .allMatches(_inputController.text)
        .map((match) => match.group(0)!)
        .toList();

    // Valida que se haya ingresado al menos un carácter válido.
    if (filteredItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese al menos una letra válida')),
      );
      return;
    }

    // Actualiza el estado para iniciar la práctica con los caracteres filtrados.
    setState(() {
      practiceItems = filteredItems;
      userResults = List.filled(practiceItems.length, null);
      isPracticing = true;
      currentItemIndex = 0;
      correctAnswers = 0;
      showResults = false;
    });
  }


  /**
   * @abstract
   * Registra el resultado (correcto o incorrecto) para el ítem actual de la práctica.
   * Avanza al siguiente ítem o finaliza la práctica si es el último.
   *
   * @param isCorrect Booleano que indica si la respuesta fue correcta.
   */
  void _recordResult(bool isCorrect) {
    if (!mounted || !isPracticing) return;

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

  /**
   * @abstract
   * Finaliza la sesión de práctica, guarda los resultados en la base de datos de Hive
   * y actualiza la UI para mostrar la pantalla de resultados.
   */
  Future<void> _finishPractice() async {
    final score = '$correctAnswers/${practiceItems.length}';
    final results = userResults.join(',');

    final practiceResult = PracticeResult(
      practiceNumber: nextPracticeNumber,
      date: DateTime.now(),
      results: results,
      score: score,
    );

    final box = Hive.box<Student>('students');
    final updatedPractices = List<PracticeResult>.from(widget.student.practices)
      ..add(practiceResult);

    final updatedStudent = Student(
      firstName: widget.student.firstName,
      lastName: widget.student.lastName,
      motherLastName: widget.student.motherLastName,
      birthDate: widget.student.birthDate,
      institution: widget.student.institution,
      practices: updatedPractices,
    );

    await box.putAt(widget.studentIndex, updatedStudent);

    setState(() {
      isPracticing = false;
      showResults = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Práctica $nextPracticeNumber guardada'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /**
   * @abstract
   * Reinicia el estado de la pantalla para permitir iniciar una nueva práctica.
   * Limpia los ítems anteriores y se prepara para una nueva entrada.
   */
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
        actions: const [],
      ),
      body: showResults
          ? _buildResultsScreen()
          : (isPracticing ? _buildPracticeSession() : _buildPracticeSetup()),
    );
  }

  /**
   * @abstract
   * Construye la vista de configuración inicial donde el tutor ingresa los
   * caracteres para la práctica.
   *
   * @return Un widget con el campo de texto y el botón de inicio.
   */
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar', style: TextStyle(fontSize: 16)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2C94C),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
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

  /**
   * @abstract
   * Construye la vista principal de la sesión de práctica, mostrando el carácter
   * actual que el alumno debe identificar.
   *
   * @return Un widget que muestra el carácter actual y los botones de control.
   */
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
                style:
                    const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Usa el teclado físico o los botones en pantalla",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.check, size: 30),
              label: const Text('Correcto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onPressed: () => _recordResult(true),
            ),
            const SizedBox(width: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.close, size: 30),
              label: const Text('Incorrecto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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

  /**
   * @abstract
   * Construye la pantalla de resultados que se muestra al finalizar la práctica.
   *
   * @return Un widget que muestra la puntuación final y opciones para continuar.
   */
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
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C3E50),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _restartPractice,
                child: const Text('Repetir Práctica'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2C94C),
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                   shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}