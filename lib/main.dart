import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/student.dart';
import 'screens/home_screen.dart';

/**
 * @abstract Punto de entrada principal de la aplicación.
 * @description Esta función se encarga de realizar las configuraciones iniciales críticas
 * antes de que la aplicación Flutter se ejecute. Asegura que los bindings de Flutter
 * estén listos, inicializa la base de datos local Hive, registra los adaptadores
 * de tipo necesarios para la serialización de datos y abre la 'box' de estudiantes.
 * En caso de un error durante la inicialización, muestra una pantalla de error.
 * @author Juan De Dios Mendoza Peinado
 * @access public
 */
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

/**
 * @abstract Widget raíz de la aplicación de gestión de alumnos.
 * @description Este widget StatelessWidget configura el MaterialApp, que es el
 * componente fundamental para una aplicación que sigue los lineamientos de Material Design.
 * Define el título, el tema global (colores, estilos de la AppBar, etc.) y establece
 * la pantalla de inicio (`HomeScreen`).
 * @author Juan De Dios Mendoza Peinado
 * @package gestion_alumnos
 * @access public
 */
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  /**
   * @abstract Construye la interfaz de usuario del widget raíz.
   * @author Juan De Dios Mendoza Peinado
   * @param {BuildContext} context El contexto del árbol de widgets.
   * @return {Widget} Retorna el widget MaterialApp configurado para la aplicación.
   * @access public
   */
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