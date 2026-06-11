import 'package:flutter/material.dart';
import '../base_de_datos/db_helper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PublicarPage extends StatefulWidget {
  final Map<String, dynamic> usuario;
  PublicarPage({required this.usuario});

  @override
  _PublicarPageState createState() => _PublicarPageState();
}

class _PublicarPageState extends State<PublicarPage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController precioController = TextEditingController();

  File? _imagenSeleccionada;
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> _misPlatillos = [];

  // 🔹 Lista fija de categorías
  final List<String> categorias = [
    "Pizzas",
    "Hamburguesas",
    "Tacos",
    "Ensaladas",
    "Pasta",
    "Postres",
    "Bebidas",
    "Otros",
  ];

  String? _categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    _cargarMisPlatillos();
  }

  Future<void> _cargarMisPlatillos() async {
    String email = widget.usuario['gmail'] ?? "";
    if (email.isNotEmpty) {
      final platillos = await DBHelper.obtenerPlatillosPorUsuario(email);
      setState(() {
        _misPlatillos = platillos;
      });
    }
  }

  Future<void> _seleccionarImagen() async {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() {
        _imagenSeleccionada = File(imagen.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Añadir nuevo plato al menú",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),

            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: "Nombre del plato *",
                hintText: "Ej: Pizza Margarita (Centro)",
              ),
            ),
            SizedBox(height: 15),

            TextField(
              controller: descripcionController,
              decoration: InputDecoration(
                labelText: "Descripción",
                hintText: "Describe tu plato...",
              ),
              maxLines: 3,
            ),
            SizedBox(height: 15),

            TextField(
              controller: precioController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Precio (Pesos) *",
                hintText: "\$12.99",
              ),
            ),
            SizedBox(height: 15),

            // 🔹 Dropdown de categorías
            DropdownButtonFormField<String>(
              value: _categoriaSeleccionada,
              items: categorias.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _categoriaSeleccionada = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Categoría *",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20),

            Text("Imagen del plato",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            GestureDetector(
              onTap: _seleccionarImagen,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _imagenSeleccionada == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo,
                                size: 40, color: Colors.deepOrange),
                            SizedBox(height: 8),
                            Text("Click para subir imagen JPG, PNG o WEBP"),
                          ],
                        ),
                      )
                    : Image.file(_imagenSeleccionada!, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: () async {
                if (nombreController.text.isNotEmpty &&
                    precioController.text.isNotEmpty &&
                    _categoriaSeleccionada != null) {
                  double precio = double.parse(precioController.text);
                  await DBHelper.insertarPlatillo(
                    widget.usuario['gmail'] ?? "",
                    nombreController.text,
                    descripcionController.text,
                    precio,
                    _imagenSeleccionada?.path ?? "assets/images/default.webp",
                    _categoriaSeleccionada!, // 👈 se guarda la categoría
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Platillo publicado ✅")),
                  );
                  _cargarMisPlatillos();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Completa todos los campos obligatorios (*)")),
                  );
                }
              },
              icon: Icon(Icons.shopping_cart),
              label: Text("Añadir al menú"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 30),

            Text("Menú actual",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            _misPlatillos.isEmpty
                ? Text("No has publicado platillos aún.")
                : Column(
                    children: _misPlatillos.map((p) {
                      return ListTile(
                        leading: p["imagen"].toString().startsWith("assets")
                            ? Image.asset(p["imagen"], width: 50, height: 50)
                            : Image.file(File(p["imagen"]),
                                width: 50, height: 50,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.fastfood)),
                        title: Text(p["nombre_platillo"]),
                        subtitle: Text(
                          "${p["descripcion"]}\n\$${p["precio"]}\nCategoría: ${p["categoria"] ?? "Sin categoría"}",
                        ),
                        trailing: Icon(Icons.check, color: Colors.green),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
