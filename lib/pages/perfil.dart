import 'package:flutter/material.dart';
import 'login_page.dart';
import 'evaluacion_vendedor.dart';
import '../base_de_datos/db_helper.dart';

class PerfilPage extends StatefulWidget {
  final Map<String, dynamic> usuario;        
  final Function(String) onRoleSelected;     

  PerfilPage({required this.usuario, required this.onRoleSelected});

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.deepOrange, Colors.orange]),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 60, color: Colors.deepOrange),
                ),
                const SizedBox(height: 15),
                Text(
                  widget.usuario['nombre'] ?? "Usuario",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.usuario['gmail'] ?? "correo@ejemplo.com",
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.delivery_dining, color: Colors.deepOrange),
                    title: const Text("Convertirme en repartidor"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.history, color: Colors.deepOrange),
                    title: const Text("Historial de compras"),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.delete_forever, color: Colors.red),
                    title: const Text(
                      "Eliminar mi cuenta",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
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
                                    String emailAEliminar = widget.usuario['gmail'] ?? "";
                                    if (emailAEliminar.isNotEmpty) {
                                      await DBHelper.eliminarUsuario(emailAEliminar);
                                    }
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => LoginPage()),
                                    );
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

                  ListTile(
                    leading: const Icon(Icons.store, color: Colors.deepOrange),
                    title: const Text("Convertirme en vendedor"),
                    subtitle: const Text("Completa tu currículum para publicar platillos"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EvaluacionVendedorPage(
                            usuario: widget.usuario, // Pasamos el usuario logueado
                            onRoleSelected: widget.onRoleSelected, // Pasamos el callback
                          ),
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}