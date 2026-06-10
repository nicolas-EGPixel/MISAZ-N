import 'package:flutter/material.dart';
import 'login_page.dart';
import 'evaluacion_vendedor.dart';
import 'evaluacion_repartidor.dart';
import '../base_de_datos/db_helper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'historial_compras.dart';

class PerfilPage extends StatefulWidget {
  final Map<String, dynamic> usuario;        
  final Function(String) onRoleSelected;     

  PerfilPage({required this.usuario, required this.onRoleSelected});

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  File? _fotoPerfil;
  final ImagePicker _picker = ImagePicker();
  late String _userEmail;

  @override
  void initState() {
    super.initState();
    _userEmail = widget.usuario['gmail'] ?? "";
    _cargarFotoPerfil();
  }

  // Carga la foto si ya existe una guardada en los datos del usuario
  void _cargarFotoPerfil() {
    if (widget.usuario['foto_perfil'] != null && widget.usuario['foto_perfil'].toString().isNotEmpty) {
      setState(() {
        _fotoPerfil = File(widget.usuario['foto_perfil']);
      });
    }
  }

  // Método para abrir la galería y seleccionar la nueva foto
  Future<void> _cambiarFoto() async {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() {
        _fotoPerfil = File(imagen.path);
      });
      // Guardamos la ruta en SQLite para que no se pierda al cerrar la app
      await DBHelper.actualizarFotoPerfil(_userEmail, imagen.path);
      // Actualizamos el mapa en memoria por si acaso
      widget.usuario['foto_perfil'] = imagen.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Encabezado del Perfil
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.deepOrange, Colors.orange]),
            ),
            child: Column(
              children: [
                // Avatar interactivo para la foto de perfil
                GestureDetector(
                  onTap: _cambiarFoto,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        backgroundImage: _fotoPerfil != null ? FileImage(_fotoPerfil!) : null,
                        child: _fotoPerfil == null
                            ? const Icon(Icons.person, size: 65, color: Colors.deepOrange)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.black87,
                          child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  widget.usuario['nombre'] ?? "Usuario",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 5),
                Text(
                  _userEmail,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // Contenedor de Opciones / Botones ordenados
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 2,
              child: Column(
                children: [
                  // 1. Historial de compras
                  ListTile(
                    leading: const Icon(Icons.history, color: Colors.deepOrange),
                    title: const Text("Historial de compras"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistorialComprasPage(usuario: widget.usuario),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),

                  // 2. Convertirme en vendedor
                  ListTile(
                    leading: const Icon(Icons.store, color: Colors.deepOrange),
                    title: const Text("Convertirme en vendedor"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EvaluacionVendedorPage(
                            usuario: widget.usuario,
                            onRoleSelected: widget.onRoleSelected,
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),

                  // 3. Convertirme en repartidor
                  ListTile(
                    leading: const Icon(Icons.delivery_dining, color: Colors.deepOrange),
                    title: const Text("Convertirme en repartidor"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                       context,
                        MaterialPageRoute(
                         builder: (context) => EvaluacionRepartidorPage(
                          usuario: widget.usuario,
                           onRoleSelected: widget.onRoleSelected,
                         ),
                        ),
                      );
                    },
                  ),
                  

                  Container(height: 10, color: Colors.grey.shade100),

                  // 🔸 NUEVO BOTÓN: Editar Perfil
                  ListTile(
                    leading: const Icon(Icons.edit, color: Colors.blue),
                    title: const Text("Editar perfil"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(usuario: widget.usuario),
                        ),
                      );
                    },
                  ),

                  // 🔸 SEPARADOR ABAJO (Cuenta)
                  Container(height: 10, color: Colors.grey.shade100),

                  // 4. Cerrar sesión
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.blueGrey),
                    title: const Text("Cerrar sesión", style: TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () {
                      // Destruye las pantallas anteriores y te manda al Login de raíz
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                      );
                    },
                  ),
                  const Divider(height: 1),

                  // 5. Eliminar mi cuenta
                  ListTile(
                    leading: const Icon(Icons.delete_forever, color: Colors.red),
                    title: const Text("Eliminar mi cuenta", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("¿Eliminar cuenta?"),
                            content: const Text("Esta acción borrará tus datos permanentemente y no se puede deshacer."),
                            actions: [
                              TextButton(
                                child: const Text("Cancelar"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
                                onPressed: () async {
                                  try {
                                    await DBHelper.eliminarUsuario(_userEmail);
                                    Navigator.pop(context); // Cierra diálogo
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginPage()),
                                      (route) => false,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Cuenta eliminada correctamente.")),
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


// 🔸 NUEVA PANTALLA PARA LA EDICIÓN DE PERFIL
class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> usuario;
  EditProfilePage({required this.usuario});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _oldPassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargamos los datos actuales en los campos
    _nombreController.text = widget.usuario['nombre'] ?? "";
    _emailController.text = widget.usuario['gmail'] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text("Editar Perfil", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Modificar Datos",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: "Nuevo Nombre", prefixIcon: Icon(Icons.person)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Nuevo Correo", prefixIcon: Icon(Icons.email)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Nueva Contraseña (Opcional)", prefixIcon: Icon(Icons.lock_outline)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Divider(color: Colors.grey),
                ),
                const Text(
                  "Confirmar Cambios",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.redAccent),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _oldPassController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Contraseña Actual (Requerida)",
                    prefixIcon: Icon(Icons.lock, color: Colors.redAccent),
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    if (_oldPassController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Debes ingresar tu contraseña actual para confirmar.")),
                      );
                      return;
                    }

                    // 1. Validamos la contraseña actual contra la base de datos
                    bool esValida = await DBHelper.verificarContrasena(widget.usuario['gmail'], _oldPassController.text);
                    
                    if (esValida) {
                      // Si no escribió una nueva contraseña, dejamos la que ya tiene
                      String nuevaContrasena = _passController.text.isEmpty ? widget.usuario['contraseña'] : _passController.text;
                      
                      // 2. Guardamos los cambios en SQLite
                      await DBHelper.actualizarUsuario(
                        widget.usuario['gmail'], 
                        _nombreController.text, 
                        _emailController.text, 
                        nuevaContrasena
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Datos actualizados. Por seguridad inicia sesión de nuevo."), backgroundColor: Colors.green),
                      );

                      // 3. Forzamos el cierre de sesión para evitar inconsistencias
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("La contraseña actual es incorrecta."), backgroundColor: Colors.red),
                      );
                    }
                  },
                  child: const Text("Guardar Cambios", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}