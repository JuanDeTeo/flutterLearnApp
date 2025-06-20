import 'package:flutter/material.dart';
import '../services/bluetooth_service.dart';
import 'info_screen.dart';
import 'students_screen.dart';
import 'practices_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  // Se crea una única instancia del servicio de Bluetooth aquí,
  // asegurando que su ciclo de vida esté atado a la pantalla principal.
  final AppBluetoothService _bluetoothService = AppBluetoothService();

  // La lista de pantallas se inicializa en initState para poder pasar el servicio.
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Se pasa la misma instancia del servicio a las pantallas que la necesiten.
    _screens = [
      StudentsScreen(bluetoothService: _bluetoothService),
      PracticesScreen(bluetoothService: _bluetoothService),
      const InfoScreen(),
    ];
  }

  @override
  void dispose() {
    // Se liberan los recursos del servicio solo cuando esta pantalla se destruye.
    _bluetoothService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Se usa IndexedStack para mantener el estado de las pantallas
      // al cambiar de pestaña, lo que mejora el rendimiento y la experiencia de usuario.
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
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Prácticas',
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
