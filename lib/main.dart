import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/student.dart';
import 'screens/home_screen.dart';

void main() async {
  // 1. Asegura que los bindings de Flutter estén inicializados antes de cualquier otra cosa.
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 2. Inicializa Hive para el almacenamiento local.
    await Hive.initFlutter();
    
    // 3. Registra los adaptadores de Hive para que sepa cómo guardar y leer tus clases.
    // Es crucial que estos adaptadores se registren antes de abrir cualquier 'box'.
    Hive.registerAdapter(StudentAdapter());
    Hive.registerAdapter(PracticeResultAdapter());
    
    // 4. Abre la 'box' (similar a una tabla en una base de datos) donde se guardarán los estudiantes.
    await Hive.openBox<Student>('students');
    
    // 5. Inicia la aplicación Flutter.
    runApp(const MyApp());
  } catch (e) {
    // Un bloque catch para manejar cualquier error durante la inicialización
    // y mostrar un mensaje útil en la pantalla.
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error al iniciar la aplicación: ${e.toString()}'),
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
      // El punto de entrada de la UI de la app es HomeScreen.
      home: const HomeScreen(),
    );
  }
}
