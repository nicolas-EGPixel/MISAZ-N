import 'package:flutter/material.dart';
import 'login_page.dart'; // 🔸 Para poder regresar al login al cerrar sesión

class PerfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: SingleChildScrollView( // ✅ Scroll para evitar overflow
        child: Column(
          children: [
            // 🔸 Encabezado con fondo naranja y datos de usuario
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/images/perfil.jpg"), // 🔸 Imagen de perfil
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Ranni",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    "ranni@email.com",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // 🔸 Sección de información personal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Información personal",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.edit, color: Colors.deepOrange),
                    title: Text("Editar datos de usuario"),
                    onTap: () {
                      // Acción para editar datos
                    },
                  ),
                ],
              ),
            ),

            Divider(),

            // 🔸 Opciones de cuenta
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Opciones de cuenta",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.store, color: Colors.deepOrange),
                    title: Text("Convertirme en vendedor"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.delivery_dining, color: Colors.deepOrange),
                    title: Text("Convertirme en repartidor"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.history, color: Colors.deepOrange),
                    title: Text("Historial de compras"),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // 🔸 Botón para cerrar sesión
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Cerrar sesión",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white), // ✅ Texto blanco
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
