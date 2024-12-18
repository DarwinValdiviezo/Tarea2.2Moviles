import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../modelo/persona.dart';

class DialogoActualizar extends StatefulWidget {
  final Persona? persona;
  final Function(String, String, String) onConfirm;

  const DialogoActualizar({
    super.key,
    this.persona,
    required this.onConfirm,
  });

  @override
  _DialogoActualizarState createState() => _DialogoActualizarState();
}

class _DialogoActualizarState extends State<DialogoActualizar> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nombreController;
  late TextEditingController apellidoController;
  late TextEditingController telefonoController;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.persona?.nombre);
    apellidoController = TextEditingController(text: widget.persona?.apellido);
    telefonoController = TextEditingController(text: widget.persona?.telefono);
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    telefonoController.dispose();
    super.dispose();
  }

  // Validaciones
  String? _validarNombre(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es obligatorio';
    }
    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    if (value.length > 30) {
      return 'El nombre no puede exceder 30 caracteres';
    }

    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]+$').hasMatch(value)) {
      return 'El nombre solo puede contener letras';
    }
    return null;
  }

  String? _validarApellido(String? value) {
    if (value == null || value.isEmpty) {
      return 'El apellido es obligatorio';
    }
    if (value.length < 2) {
      return 'El apellido debe tener al menos 2 caracteres';
    }
    if (value.length > 30) {
      return 'El apellido no puede exceder 30 caracteres';
    }

    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]+$').hasMatch(value)) {
      return 'El apellido solo puede contener letras';
    }
    return null;
  }

  String? _validarTelefono(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es obligatorio';
    }
    final phoneRegex = RegExp(r'^\+?(\d{10,14})$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'\s|-'), ''))) {
      return 'Ingrese un número de teléfono válido';
    }
    return null;
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      String nombre = nombreController.text.trim();
      String apellido = apellidoController.text.trim();
      String telefono = telefonoController.text.trim();

      nombre = nombre[0].toUpperCase() + nombre.substring(1).toLowerCase();
      apellido =
          apellido[0].toUpperCase() + apellido.substring(1).toLowerCase();

      widget.onConfirm(nombre, apellido, telefono);
      Navigator.of(context).pop();
    }
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color(0xFF6200EE)),
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFF6200EE)),
        errorStyle: TextStyle(color: Colors.red),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFF6200EE).withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFF6200EE), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFBBDEFB),
              Color(0xFFE3F2FD),
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.persona == null
                    ? "Agregar Contacto"
                    : "Actualizar Contacto",
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6200EE),
                ),
              ),
              SizedBox(height: 20),
              _buildCustomTextField(
                controller: nombreController,
                label: "Nombre",
                icon: Icons.person,
                validator: _validarNombre,
              ),
              SizedBox(height: 15),
              _buildCustomTextField(
                controller: apellidoController,
                label: "Apellido",
                icon: Icons.person_outline,
                validator: _validarApellido,
              ),
              SizedBox(height: 15),
              _buildCustomTextField(
                controller: telefonoController,
                label: "Teléfono",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: _validarTelefono,
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text(
                      "Cancelar",
                      style: TextStyle(color: Color(0xFF6200EE)),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6200EE),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Guardar",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _guardar,
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
