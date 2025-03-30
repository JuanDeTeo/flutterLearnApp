import 'package:flutter/material.dart';
import 'info_screen.dart';
import 'students_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Lista de pantallas correspondientes a cada ícono
  final List<Widget> _screens = [
    const StudentsScreen(),
    const InfoScreen(),
    const Placeholder(), // Pantalla vacía para futuras funcionalidades
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cuerpo principal que cambia según la pestaña seleccionada
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      
      // Barra de navegación inferior
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF2C3E50), // Color seleccionado
            unselectedItemColor: const Color(0xFF708238).withOpacity(0.6), // Color no seleccionado
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 10,
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
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz),
                label: 'Más',
              ),
            ],
          ),
        ),
      ),
    );
  }
}