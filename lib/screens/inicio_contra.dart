import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../databases/db_helper.dart';
import './registro.dart';
import './loged/bienvenida.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  void _login() async {
    String usuario = _usuarioController.text;
    String contrasena = _contrasenaController.text;

    // Validar si el usuario y la contraseña coinciden en la base de datos
    List<Usuario> usuarios = await DatabaseHelper.instance.queryAllRows();
    Usuario usuarioEncontrado = usuarios.firstWhere(
      (user) => user.usuario == usuario && user.contrasena == contrasena,
      orElse: () => Usuario(usuario: '', contrasena: ''),
    );

    if (usuarioEncontrado.usuario.isNotEmpty) {
      // Ir a la pantalla de bienvenida si la autenticación es exitosa
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BienvenidaScreen(usuarioEncontrado.usuario),
        ),
      );
    } else {
      // Mostrar un mensaje de error si la autenticación falla
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error de Autenticación'),
          content: const Text('Usuario o contraseña incorrectos.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _irARegistro() {
    // Navegar a la pantalla de registro
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegistroScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
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
              onPressed: _login,
              child: const Text('Iniciar Sesión'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _irARegistro,
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
