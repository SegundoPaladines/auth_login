import 'package:flutter/material.dart';

class BienvenidaScreen extends StatelessWidget {
  final String nombreUsuario;

  const BienvenidaScreen(this.nombreUsuario, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('¡Bienvenido, $nombreUsuario!'),
            // Puedes agregar más contenido aquí según sea necesario
          ],
        ),
      ),
    );
  }
}