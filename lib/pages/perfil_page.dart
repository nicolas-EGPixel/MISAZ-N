import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.deepOrange,
              child: Icon(Icons.person, size: 48, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text('Nombre de usuario', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('correo@ejemplo.com', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 24),
            Text('Mi información', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text('Aquí puedes mostrar datos del perfil, pedidos recientes o ajustes.'),
          ],
        ),
      ),
    );
  }
}
