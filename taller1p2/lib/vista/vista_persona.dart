import 'package:flutter/material.dart';
import '../modelo/persona.dart';
import '../controlador/controlador_persona.dart';
import '../widgets/dialogo_actualizar.dart';
import 'package:google_fonts/google_fonts.dart';

class VistaPersona extends StatefulWidget {
  @override
  _VistaPersonaState createState() => _VistaPersonaState();
}

class _VistaPersonaState extends State<VistaPersona> {
  final ControladorPersona controlador = ControladorPersona();
  List<Persona> listaPersonas = [];

  @override
  void initState() {
    super.initState();
    _cargarPersonas();
  }

  void _cargarPersonas() async {
    try {
      final personas = await controlador.obtenerPersonas();
      setState(() {
        listaPersonas = personas;
      });
    } catch (e) {
      _mostrarMensaje("Error al cargar personas", false);
    }
  }

  void _mostrarMensaje(String mensaje, bool exito) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: exito ? Colors.green : Colors.red,
      ),
    );
  }

  void _mostrarDialogoActualizar({Persona? persona}) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogoActualizar(
          persona: persona,
          onConfirm: (nombre, apellido, telefono) async {
            if (persona == null) {
              _agregarPersona(Persona(
                id: '',
                nombre: nombre,
                apellido: apellido,
                telefono: telefono,
              ));
            } else {
              _actualizarPersona(Persona(
                id: persona.id,
                nombre: nombre,
                apellido: apellido,
                telefono: telefono,
              ));
            }
          },
        );
      },
    );
  }

  void _agregarPersona(Persona persona) async {
    try {
      await controlador.agregarPersona(persona);
      _mostrarMensaje("Persona agregada correctamente", true);
      _cargarPersonas();
    } catch (e) {
      _mostrarMensaje("Error al agregar persona", false);
    }
  }

  void _actualizarPersona(Persona persona) async {
    try {
      await controlador.actualizarPersona(persona);
      _mostrarMensaje("Persona actualizada correctamente", true);
      _cargarPersonas();
    } catch (e) {
      _mostrarMensaje("Error al actualizar persona", false);
    }
  }

  void _eliminarPersona(String id) async {
    final confirmacion = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmar eliminación"),
        content: Text("¿Estás seguro de que quieres eliminar esta persona?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancelar")),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Eliminar")),
        ],
      ),
    );

    if (confirmacion == true) {
      try {
        await controlador.eliminarPersona(id);
        _mostrarMensaje("Persona eliminada correctamente", true);
        _cargarPersonas();
      } catch (e) {
        _mostrarMensaje("Error al eliminar persona", false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F4F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF2C3E50),
        title: Text(
          "Contactos",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.1,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: listaPersonas.length,
        itemBuilder: (context, index) {
          final persona = listaPersonas[index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: Color(0xFF3498DB), // Vibrant blue
                child: Text(
                  persona.nombre[0].toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              title: Text(
                "${persona.nombre} ${persona.apellido}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF2C3E50),
                ),
              ),
              subtitle: Text(
                "Teléfono: ${persona.telefono}",
                style: GoogleFonts.poppins(
                  color: Colors.grey[700],
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Color(0xFF2980B9)),
                    onPressed: () =>
                        _mostrarDialogoActualizar(persona: persona),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Color(0xFFE74C3C)),
                    onPressed: () => _eliminarPersona(persona.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarDialogoActualizar(),
        backgroundColor: Color(0xFF3498DB), // Vibrant blue
        elevation: 6,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          "Agregar Contacto",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
