import 'package:flutter/material.dart';
import 'login_page.dart';
import '../base_de_datos/db_helper.dart';

class PerfilPage extends StatefulWidget {
  final Map<String, dynamic> usuario;        // ✅ Recibe el usuario
  final Function(String) onRoleSelected;     // ✅ Callback para roles

  PerfilPage({required this.usuario, required this.onRoleSelected});

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  void _showForm(String role) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(role == "publicar" ? "Currículum de vendedor" : "Formulario de repartidor"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (role == "publicar") ...[
                  TextField(decoration: InputDecoration(labelText: "Nombre del negocio *")),
                  SizedBox(height: 12),
                  TextField(decoration: InputDecoration(labelText: "Tipo de negocio *")),
                  SizedBox(height: 12),
                  TextField(decoration: InputDecoration(labelText: "Dirección del negocio *")),
                  SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(labelText: "Teléfono de contacto"),
                    keyboardType: TextInputType.number, // ✅ solo números
                  ),
                  SizedBox(height: 12),
                  TextField(decoration: InputDecoration(labelText: "Email del negocio")),
                  SizedBox(height: 12),
                  TextField(decoration: InputDecoration(labelText: "Descripción del negocio")),
                  SizedBox(height: 12),
                  TextField(decoration: InputDecoration(labelText: "Años de experiencia en el sector")),
                  SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(labelText: "Número de licencia comercial *"),
                    keyboardType: TextInputType.number, // ✅ solo números
                  ),
                  SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: "Horario de atención"),
                    items: [
                      "Lun-Vie 9:00–18:00",
                      "Lun-Sab 10:00–20:00",
                      "Lun-Dom 10:00–23:00",
                    ].map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
                    onChanged: (val) {},
                  ),
                ] else if (role == "entregas") ...[
                  TextField(decoration: InputDecoration(labelText: "Tipo de vehículo *")),
                  SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(labelText: "Número de licencia de conducir *"),
                    keyboardType: TextInputType.number, // ✅ solo números
                  ),
                  SizedBox(height: 12),
                  TextField(decoration: InputDecoration(labelText: "Experiencia como repartidor *")),
                  SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: "Disponibilidad horaria *"),
                    items: [
                      "Lun-Vie 9:00–18:00",
                      "Lun-Sab 10:00–20:00",
                      "Lun-Dom 10:00–23:00",
                    ].map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
                    onChanged: (val) {},
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
              child: Text("Enviar solicitud", style: TextStyle(color: Colors.white)),
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
    final usuario = widget.usuario;

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔸 Encabezado con datos reales
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
                  Text(usuario["nombre"],
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(usuario["gmail"],
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                    leading: const Icon(Icons.history, color: Colors.deepOrange),
                    title: const Text("Historial de compras"),
                    onTap: () {},
                  ),

                  const Divider(), // Una línea sutil separadora

                  // 🔴 BOTÓN VISUAL PARA ELIMINAR CUENTA
                  ListTile(
                    leading: const Icon(Icons.delete_forever, color: Colors.red),
                    title: const Text(
                      "Eliminar mi cuenta",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      // Cuadro de diálogo para confirmar y evitar accidentes
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("¿Eliminar cuenta permanentemente?"),
                            content: const Text(
                              "Esta acción borrará por completo tus datos de Mi Sazón de forma irreversible. ¿Deseas continuar?"
                            ),
                            actions: [
                              TextButton(
                                child: const Text("Cancelar"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: const Text("Eliminar", style: TextStyle(color: Colors.white)),
                                onPressed: () async {
                                  try {
                                    // Extraemos el correo que tiene la sesión actual usando la clave 'gmail'
                                    String emailAEliminar = widget.usuario['gmail'] ?? "";

                                    if (emailAEliminar.isNotEmpty) {
                                      // Llamamos a la función que acabamos de guardar
                                      await DBHelper.eliminarUsuario(emailAEliminar);
                                    }

                                    // Cerramos el cuadro de diálogo
                                    Navigator.pop(context);

                                    // Mandamos al usuario de regreso a la pantalla de Login
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => LoginPage()),
                                    );

                                    // Notificación en pantalla
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Tu cuenta ha sido eliminada correctamente."),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  } catch (e) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Error al eliminar cuenta: $e")),
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ], // Cierre de las opciones del Card
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
