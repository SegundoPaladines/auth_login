import 'package:flutter/material.dart';
import './inicio_contra.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de autenticación por huella
              },
              child: const Text('Autenticación por Huella'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de autenticación facial
              },
              child: const Text('Autenticación Facial'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de autenticación por contraseña
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('Autenticación por Contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}