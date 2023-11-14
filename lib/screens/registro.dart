import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../databases/db_helper.dart';
import './loged/bienvenida.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  void _registrar() async {
    String usuario = _usuarioController.text;
    String contrasena = _contrasenaController.text;

    // Realizar el registro en la base de datos
    await DatabaseHelper.instance.insert(
      Usuario(usuario: usuario, contrasena: contrasena),
    );

    // Navegar a la pantalla de bienvenida después del registro exitoso
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BienvenidaScreen(usuario),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrarse'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usuarioController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _contrasenaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registrar,
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}