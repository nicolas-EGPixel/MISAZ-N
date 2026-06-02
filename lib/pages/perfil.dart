import 'package:flutter/material.dart';
import 'login_page.dart';

class PerfilPage extends StatefulWidget {
  final Function(String) onRoleSelected; 
  // 🔸 Callback para avisar al HomePage que se eligió un rol

  PerfilPage({required this.onRoleSelected});

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  void _showForm(String role) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Formulario para $role"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Nombre completo"),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Teléfono"),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Dirección"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
              child: Text("Confirmar", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pop(context);
                widget.onRoleSelected(role); // 🔸 Avisamos al HomePage
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔸 Encabezado
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
                    backgroundImage: AssetImage("assets/images/perfil.jpg"),
                  ),
                  SizedBox(height: 10),
                  Text("Juan Pérez",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text("juan.perez@email.com",
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),

            SizedBox(height: 20),

            // 🔸 Información personal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Información personal",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.edit, color: Colors.deepOrange),
                    title: Text("Editar datos de usuario"),
                    onTap: () {},
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
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.store, color: Colors.deepOrange),
                    title: Text("Convertirme en vendedor"),
                    onTap: () => _showForm("publicar"),
                  ),
                  ListTile(
                    leading: Icon(Icons.delivery_dining, color: Colors.deepOrange),
                    title: Text("Convertirme en repartidor"),
                    onTap: () => _showForm("entregas"),
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

            // 🔸 Botón cerrar sesión
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
                child: Text("Cerrar sesión",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
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
