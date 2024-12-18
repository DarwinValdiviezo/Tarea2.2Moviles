import 'package:flutter/material.dart';
import 'vista/vista_persona.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gestión de Personas",
      home: VistaPersona(),
      debugShowCheckedModeBanner: false,
    );
  }
}
