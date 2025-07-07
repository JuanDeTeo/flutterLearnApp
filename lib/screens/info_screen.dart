import 'package:flutter/material.dart';

/**
 * @author Juan De Dios Mendoza Peinado
 * * @abstract
 * Una pantalla estática que muestra información relevante sobre la aplicación.
 * Incluye secciones sobre cómo usar la app, la institución, el propósito y el creador.
 * Es un widget sin estado ya que su contenido no cambia.
 */
class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Estilo de texto base para el manual
    const baseStyle = TextStyle(fontSize: 16, height: 1.5, color: Colors.black87);
    // Estilo para los títulos de las secciones del manual
    const titleStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black, height: 1.8);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Información'),
        backgroundColor: const Color(0xFF2C3E50),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          // Sección: Cómo usar la aplicación (Expandible)
          const Card(
            elevation: 2,
            child: ExpansionTile(
              leading: Icon(Icons.help_outline, color: Color(0xFF2C3E50)),
              title: Text(
                'Guía Rápida de Uso',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF2C3E50),
                ),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                  child: Text(
                    '1. Dirígete a la pestaña "Alumnos" para registrar un nuevo estudiante usando el botón "+".\n\n'
                    '2. Una vez registrado, el alumno aparecerá en la lista. Puedes editar o eliminar su información usando los iconos correspondientes.\n\n'
                    '3. Para iniciar una lección, pulsa el icono de práctica (con forma de libreta) en el perfil del alumno.\n\n'
                    '4. Conecta el dispositivo Bluetooth desde el icono en la esquina superior derecha para que el alumno pueda interactuar con el sistema braille.\n\n'
                    '5. Ingresa los caracteres de la lección y comienza la práctica. El sistema registrará las respuestas del alumno.\n\n'
                    '6. Al finalizar, podrás ver los resultados, que también quedarán guardados en el historial del alumno.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Sección: Manual de Usuario Detallado (Expandible)
          Card(
            elevation: 2,
            child: ExpansionTile(
              leading: const Icon(Icons.book_outlined, color: Color(0xFF2C3E50)),
              title: const Text(
                'Manual de Usuario Detallado',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF2C3E50),
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                  child: RichText(
                    text: const TextSpan(
                      style: baseStyle,
                      children: [
                        TextSpan(
                          text: 'Gestión de Alumnos:\n',
                          style: titleStyle,
                        ),
                        TextSpan(text: '• Para agregar un nuevo alumno, pulsa el botón amarillo '),
                        WidgetSpan(child: Icon(Icons.add_circle, color: Color(0xFFF2C94C), size: 18)),
                        TextSpan(text: ' en la pestaña "Alumnos".\n'),
                        TextSpan(text: '• En la lista, cada alumno tiene tres iconos: '),
                        WidgetSpan(child: Icon(Icons.assignment, color: Color(0xFF708238), size: 18)),
                        TextSpan(text: ' (Iniciar Práctica), '),
                        WidgetSpan(child: Icon(Icons.edit, color: Colors.blue, size: 18)),
                        TextSpan(text: ' (Editar) y '),
                        WidgetSpan(child: Icon(Icons.delete, color: Colors.red, size: 18)),
                        TextSpan(text: ' (Eliminar).\n'),
                        TextSpan(text: '• Pulsa sobre el nombre de un alumno para ver su historial de prácticas detallado.\n\n'),

                        TextSpan(
                          text: 'Conexión Bluetooth:\n',
                          style: titleStyle,
                        ),
                        TextSpan(text: '• En la esquina superior derecha de "Alumnos", pulsa el icono de Bluetooth: '),
                        WidgetSpan(child: Icon(Icons.bluetooth_disabled, color: Colors.grey, size: 18)),
                        TextSpan(text: ' (desconectado) o '),
                        WidgetSpan(child: Icon(Icons.bluetooth_connected, color: Colors.lightBlueAccent, size: 18)),
                        TextSpan(text: ' (conectado).\n'),
                        TextSpan(text: '• Selecciona tu dispositivo Braille de la lista para conectar.\n\n'),

                        TextSpan(
                          text: 'Realizar una Práctica:\n',
                          style: titleStyle,
                        ),
                        TextSpan(text: '1. Pulsa el icono de práctica '),
                        WidgetSpan(child: Icon(Icons.assignment, color: Color(0xFF708238), size: 18)),
                        TextSpan(text: ' del alumno.\n'),
                        TextSpan(text: '2. Ingresa los caracteres para la lección separados por comas (ej: a,b,sol,1).\n'),
                        TextSpan(text: '3. Durante la práctica, la app registrará las respuestas del dispositivo Bluetooth o puedes usar los botones en pantalla.\n'),
                        TextSpan(text: '4. Al finalizar, los resultados se guardan automáticamente.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          const Card(
            elevation: 2,
            child: ExpansionTile(
              leading: Icon(Icons.help_outline, color: Color(0xFF2C3E50)),
              title: Text(
                'Institución',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF2C3E50),
                ),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                  child: Text(
                    'UNIVERSIDAD AUTÓNOMA DE SINALOA\n\n'
                    'FACULTAD DE INFORMÁTICA MAZATLÁN\n\n',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),


          Card(
  elevation: 2,
  child: ExpansionTile(
    leading: const Icon(Icons.info_outline, color: Color(0xFF2C3E50)),
    title: const Text(
      'Para qué se creó esta aplicación',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Color(0xFF2C3E50),
      ),
    ),
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
        child: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 16, height: 1.4, color: Colors.black87),
            children: [
              TextSpan(
                text: 'Propósito principal:\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: 'Apoyar en la enseñanza de braille a alumnos con capacidades diferentes.\n\n'),
              
              TextSpan(
                text: 'Beneficios:\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: '• Facilita el aprendizaje del sistema braille\n'),
              TextSpan(text: '• Permite seguimiento del progreso de los alumnos\n'),
              TextSpan(text: '• Integra tecnología para una enseñanza más efectiva'),
            ],
          ),
        ),
      ),
    ],
  ),
),
          const SizedBox(height: 12),

          // Sección: Creador
          const Card(
            elevation: 2,
            child: ExpansionTile(
              leading: Icon(Icons.people, color: Color(0xFF2C3E50)),
              title: Text(
                'Equipo de desarrollo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF2C3E50),
                ),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(fontSize: 16, height: 1.5),
                      children: [
                        // Diseño y desarrollo
                        TextSpan(
                          text: 'Diseño y desarrollo\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: 'Ing. Juan De Dios Mendoza Peinado\n\n'),

                        // Lider del proyecto
                        TextSpan(
                          text: 'Lider del proyecto\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: 'Dr. Jose Alfonso Aguilar Calderon\n\n'),

                        // Colaboradores
                        TextSpan(
                          text: 'Colaboradores\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: 'Dr. Anibal Zaldivar Colado\n'),
                        TextSpan(text: 'Dra. Carolina Tripp Barba\n'),
                        TextSpan(text: 'Mc. Juan Jose Rodriguez\n\n'),

                        // Alumnos
                        TextSpan(
                          text: 'Alumnos\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: 'Jose Humberto Verdugo Sanchez\n'),
                        TextSpan(text: 'Daniel Antonio Vareta Ortega\n'),
                        TextSpan(text: 'Gustavo Uriel Lopez Rebollo'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

/**
 * @abstract
 * Widget auxiliar para mostrar información en una tarjeta estilizada y reutilizable.
 * * @param title El título que se mostrará en la parte superior de la tarjeta.
 * @param content El contenido principal de la tarjeta.
 */
class _InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const _InfoCard({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}