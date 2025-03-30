import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/student.dart';
import 'screens/home_screen.dart';

void main() async {
  // 1. Asegurar la inicialización de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 2. Configurar Hive con la ruta adecuada
    await Hive.initFlutter();
    
    // 3. Registrar todos los adaptadores necesarios
    Hive.registerAdapter(StudentAdapter());
    Hive.registerAdapter(PracticeResultAdapter()); // Adaptador para los resultados
    
    // 4. Abrir la box de estudiantes
    await Hive.openBox<Student>('students');
    
    // 5. Iniciar la aplicación
    runApp(const MyApp());
  } catch (e) {
    // Manejo de errores durante la inicialización
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error al iniciar: ${e.toString()}'),
          ),
        ),
      ),
    );
  }
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
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFF2C94C),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}