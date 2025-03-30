import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/student.dart';
import '../services/hive_service.dart';

class AddEditStudent extends StatefulWidget {
  final Student? student;
  final int? index;

  const AddEditStudent({Key? key, this.student, this.index}) : super(key: key);

  @override
  State<AddEditStudent> createState() => _AddEditStudentState();
}

class _AddEditStudentState extends State<AddEditStudent> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _motherLastNameController;
  late TextEditingController _institutionController;
  DateTime? _birthDate;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.student?.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.student?.lastName ?? '');
    _motherLastNameController = TextEditingController(text: widget.student?.motherLastName ?? '');
    _institutionController = TextEditingController(text: widget.student?.institution ?? '');
    _birthDate = widget.student?.birthDate;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _motherLastNameController.dispose();
    _institutionController.dispose();
    super.dispose();
  }

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