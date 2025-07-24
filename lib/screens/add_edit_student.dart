import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/student.dart';
import '../services/hive_service.dart';

/**
 * @author Juan De Dios Mendoza Peinado
 *
 * @abstract
 * Una pantalla que permite agregar un nuevo estudiante o editar uno existente.
 * Utiliza un formulario para capturar los datos del estudiante y los guarda
 * en la base de datos de Hive a través de [HiveService].
 *
 * @param student El estudiante a editar. Si es nulo, 
 * la pantalla funciona en modo "Agregar".
 * @param index El índice del estudiante en la caja de Hive, 
 * necesario para la actualización.
 *
 * @package
 */
class AddEditStudent extends StatefulWidget {
  final Student? student;
  final int? index;

  const AddEditStudent({Key? key, this.student, this.index}) : super(key: key);

  @override
  State<AddEditStudent> createState() => _AddEditStudentState();
}

/**
 * @abstract
 * El estado asociado con [AddEditStudent]. Gestiona el formulario, los controladores
 * de texto y la lógica para guardar o actualizar un estudiante.
 */
class _AddEditStudentState extends State<AddEditStudent> {
  /**
   * @var _formKey Clave global para validar el estado del formulario.
   */
  final _formKey = GlobalKey<FormState>();

  /**
   * @var _firstNameController Controlador para el campo de texto del nombre.
   */
  late TextEditingController _firstNameController;
  
  /**
   * @var _lastNameController Controlador para el campo de texto del apellido paterno.
   */
  late TextEditingController _lastNameController;
  
  /**
   * @var _motherLastNameController Controlador para el campo de texto del apellido materno.
   */
  late TextEditingController _motherLastNameController;
  
  /**
   * @var _institutionController Controlador para el campo de texto de la institución.
   */
  late TextEditingController _institutionController;
  
  /**
   * @var _birthDate La fecha de nacimiento seleccionada para el estudiante.
   */
  DateTime? _birthDate;

  /**
   * @abstract
   * Inicializa el estado del widget. Si se proporciona un estudiante, los campos
   * del formulario se llenan con sus datos existentes.
   */
  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.student?.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.student?.lastName ?? '');
    _motherLastNameController = TextEditingController(text: widget.student?.motherLastName ?? '');
    _institutionController = TextEditingController(text: widget.student?.institution ?? '');
    _birthDate = widget.student?.birthDate;
  }

  /**
   * @abstract
   * Libera los recursos utilizados por los [TextEditingController] cuando el
   * widget se elimina del árbol de widgets.
   */
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _motherLastNameController.dispose();
    _institutionController.dispose();
    super.dispose();
  }

  /**
   * @abstract
   * Muestra un [showDatePicker] para que el usuario seleccione la fecha de nacimiento.
   * La fecha seleccionada se guarda en la variable de estado [_birthDate].
   *
   * @param context El contexto de compilación del widget.
   * @return Un [Future] que se completa cuando el usuario cierra el selector de fecha.
   */
  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() => _birthDate = pickedDate);
    }
  }

  /**
   * @abstract
   * Valida el formulario y, si es válido, crea un objeto [Student] con los datos
   * ingresados. Luego, utiliza [HiveService] para agregar o actualizar el estudiante
   * en la base de datos y cierra la pantalla.
   */
  void _saveStudent() {
    if (_formKey.currentState!.validate() && _birthDate != null) {
      final student = Student(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        motherLastName: _motherLastNameController.text,
        birthDate: _birthDate!,
        institution: _institutionController.text,
      );

      if (widget.index != null) {
        HiveService.updateStudent(widget.index!, student);
      } else {
        HiveService.addStudent(student);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Agregar Alumno' : 'Editar Alumno'),
        backgroundColor: const Color(0xFF2C3E50),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) => value!.isEmpty ? 'Ingrese el nombre' : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Apellido Paterno'),
                validator: (value) => value!.isEmpty ? 'Ingrese el apellido paterno' : null,
              ),
              TextFormField(
                controller: _motherLastNameController,
                decoration: const InputDecoration(labelText: 'Apellido Materno'),
                validator: (value) => value!.isEmpty ? 'Ingrese el apellido materno' : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha de Nacimiento',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _birthDate == null
                            ? 'Seleccione fecha'
                            : DateFormat('dd/MM/yyyy').format(_birthDate!),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _institutionController,
                decoration: const InputDecoration(labelText: 'Institución'),
                validator: (value) => value!.isEmpty ? 'Ingrese la institución' : null,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF708238),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF2C94C),
                    ),
                    onPressed: _saveStudent,
                    child: Text(widget.student == null ? 'Guardar' : 'Actualizar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}