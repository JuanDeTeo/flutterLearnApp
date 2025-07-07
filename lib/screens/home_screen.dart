import 'package:flutter/material.dart';
import '../services/bluetooth_service.dart';
import 'info_screen.dart';
import 'students_screen.dart';

/**
 * @author Juan De Dios Mendoza Peinado
 * * @abstract
 * La pantalla principal de la aplicación que contiene la barra de navegación inferior.
 * Gestiona la navegación entre las pantallas principales: Alumnos e Información.
 * También inicializa y gestiona el ciclo de vida del servicio de Bluetooth.
 */
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/**
 * @abstract
 * El estado de la [HomeScreen]. Administra el índice de la pantalla actual
 * y la instancia del servicio de Bluetooth.
 */
class _HomeScreenState extends State<HomeScreen> {
  /**
   * @var _currentIndex El índice de la pestaña de navegación actualmente seleccionada.
   */
  int _currentIndex = 0;
  
  /**
   * @var _bluetoothService La instancia única del servicio de Bluetooth compartida en toda la app.
   */
  final AppBluetoothService _bluetoothService = AppBluetoothService();

  /**
   * @var _screens La lista de widgets de pantalla para la navegación.
   */
  late final List<Widget> _screens;

  /**
   * @abstract
   * Inicializa el estado, creando la lista de pantallas y pasando la instancia
   * del servicio de Bluetooth a las pantallas que la necesitan.
   */
  @override
  void initState() {
    super.initState();
    _screens = [
      StudentsScreen(bluetoothService: _bluetoothService),
      const InfoScreen(),
    ];
  }

  /**
   * @abstract
   * Libera los recursos del servicio de Bluetooth cuando la pantalla principal se destruye.
   */
  @override
  void dispose() {
    _bluetoothService.dispose();
    super.dispose();
  }

  /**
   * @abstract
   * Construye la UI de la pantalla principal, que consiste en un IndexedStack para
   * mantener el estado de las pantallas y una BottomNavigationBar para la navegación.
   * * @return Un widget Scaffold que estructura la pantalla principal.
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF2C3E50),
        unselectedItemColor: const Color(0xFF708238).withOpacity(0.6),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Alumnos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            activeIcon: Icon(Icons.info),
            label: 'Información',
          ),
        ],
      ),
    );
  }
}