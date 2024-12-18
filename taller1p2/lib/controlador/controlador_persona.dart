import 'package:http/http.dart' as http;
import 'dart:convert';
import '../modelo/persona.dart';

class ControladorPersona {
  final String _baseUrl = "http://localhost:5000/api/personas";

  // Litsta
  Future<List<Persona>> obtenerPersonas() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Persona.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener personas");
    }
  }

  // Post
  Future<void> agregarPersona(Persona persona) async {
    await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(persona.toJson()),
    );
  }

  // Put
  Future<void> actualizarPersona(Persona persona) async {
    await http.put(
      Uri.parse("$_baseUrl/${persona.id}"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(persona.toJson()),
    );
  }

  // Delete
  Future<void> eliminarPersona(String id) async {
    await http.delete(Uri.parse("$_baseUrl/$id"));
  }
}
