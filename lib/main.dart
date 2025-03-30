import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';
import 'models/student.dart';

void main() async {
  // 1. Asegurar la inicialización de Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Configurar Hive
  await _initializeHive();
  
  // 3. Lanzar la aplicación
  runApp(const MyApp());
}

Future<void> _initializeHive() async {
  // Inicializar Hive con la ruta adecuada
  await Hive.initFlutter();
  
  // Registrar el adaptador del modelo Student
  Hive.registerAdapter(StudentAdapter());
  
  // Abrir la box de estudiantes
  await Hive.openBox<Student>('students');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Alumnos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF2C3E50), // Color primario
          secondary: const Color(0xFFF2C94C), // Color secundario
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2C3E50),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const HomeScreen(), // ¡Aquí está el cambio importante!
    );
  }
}