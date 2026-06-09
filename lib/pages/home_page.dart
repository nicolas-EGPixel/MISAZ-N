import 'package:flutter/material.dart';
import 'mapa.dart';
import 'favoritos.dart';
import 'perfil.dart';
import 'food_detail_page.dart';
import 'entregas.dart';
import '../base_de_datos/db_helper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// 🔸 PANTALLA DE PUBLICAR PLATILLOS
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
  final TextEditingController categoriaController = TextEditingController();

  File? _imagenSeleccionada;
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> _misPlatillos = [];

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

            TextField(
              controller: categoriaController,
              decoration: InputDecoration(
                labelText: "Categoría",
                hintText: "Pizzas, Pasta...",
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
                    precioController.text.isNotEmpty) {
                  double precio = double.parse(precioController.text);
                  await DBHelper.insertarPlatillo(
                    widget.usuario['gmail'] ?? "",
                    nombreController.text,
                    descripcionController.text,
                    precio,
                    _imagenSeleccionada?.path ?? "assets/images/default.webp",
                    categoriaController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Platillo publicado ✅")),
                  );
                  _cargarMisPlatillos();
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
                        subtitle: Text("${p["descripcion"]}\n\$${p["precio"]}"),
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

// 🔸 HOME PAGE
class HomePage extends StatefulWidget {
  final Map<String, dynamic> usuario;
  HomePage({required this.usuario});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _esVendedor = false;
  bool _esRepartidor = false;
  List<Map<String, dynamic>> platillos = [];

  final List<Map<String, dynamic>> categories = [
    {"icon": Icons.local_pizza, "label": "Pizzas"},
    {"icon": Icons.fastfood, "label": "Hamburguesas"},
    {"icon": Icons.rice_bowl, "label": "Sushi"},
    {"icon": Icons.local_dining, "label": "Mexicana"},
    {"icon": Icons.eco, "label": "Ensaladas"},
    {"icon": Icons.set_meal, "label": "Pasta"},
    {"icon": Icons.cake, "label": "Postres"},
    {"icon": Icons.local_drink, "label": "Bebidas"},
  ];

  @override
  void initState() {
    super.initState();
    _verificarRolVendedor();
    _verificarRolRepartidor();
    _cargarPlatillos();
  }

  void _verificarRolVendedor() async {
    bool vendedor = await DBHelper.esVendedor(widget.usuario['gmail'] ?? "");
    setState(() {
      _esVendedor = vendedor;
    });
  }

  void _verificarRolRepartidor() async {
  final repartidor = await DBHelper.obtenerRepartidorPorUsuario(widget.usuario['gmail'] ?? "");
  setState(() {
    _esRepartidor = repartidor != null; // true si existe registro en tb_repartidor
  });
}

  void _cargarPlatillos() async {
    final data = await DBHelper.getPlatillos();
    setState(() {
      platillos = data;
    });
  }

  List<Widget> _obtenerPaginas() {
    return [
      _inicioPage(),
      MapaPage(),
      if (_esVendedor) PublicarPage(usuario: widget.usuario),
      if (_esRepartidor) EntregasPage(usuario: widget.usuario), // 👈 nueva
      FavoritosPage(),
      PerfilPage(
        usuario: widget.usuario,
        onRoleSelected: (String role) {
          _verificarRolVendedor();
          _verificarRolRepartidor(); // 👈 actualizar también repartidor
        },
      ),
    ];
  }

  List<BottomNavigationBarItem> _obtenerItems() {
  return [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
    const BottomNavigationBarItem(icon: Icon(Icons.map), label: "Mapa"),
    if (_esVendedor)
      const BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Publicar"),
    if (_esRepartidor)
      const BottomNavigationBarItem(icon: Icon(Icons.delivery_dining), label: "Entregas"), // 👈 nueva
    const BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favoritos"),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
  ];
}


  @override
  Widget build(BuildContext context) {
    final navItems = _obtenerItems();

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(navItems[_selectedIndex].label ?? "Mi Sazón"),
      ),
      body: _obtenerPaginas()[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: navItems,
      ),
    );
  }

    Widget _inicioPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔎 Buscador
          TextField(
            decoration: InputDecoration(
              hintText: "Buscar alimentos...",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          SizedBox(height: 20),

          // 📂 Categorías
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final item = categories[index];
              return Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.deepOrange.shade100,
                    child: Icon(item["icon"], size: 28, color: Colors.deepOrange),
                  ),
                  SizedBox(height: 6),
                  Text(item["label"], style: TextStyle(fontSize: 12)),
                ],
              );
            },
          ),
          SizedBox(height: 30),

          // ⭐ Recomendaciones
          Text("Recomendaciones",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 15),

          platillos.isEmpty
              ? Text("No hay platillos publicados aún.")
              : Column(
                  children: platillos.map((p) {
                    return _foodCard(
                      p["nombre_platillo"],
                      p["descripcion"],
                      p["imagen"],
                      4.5, // rating fijo
                      128, // reviews fijos
                      p["precio"] is int
                          ? (p["precio"] as int).toDouble()
                          : p["precio"],
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _foodCard(String title, String description, String imagePath,
      double rating, int reviews, double price) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailPage(
              title: title,
              description: description,
              imagePath: imagePath,
              rating: rating,
              reviews: reviews,
              price: price,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: imagePath.toString().startsWith("assets")
                  ? Image.asset(imagePath,
                      height: 160, width: double.infinity, fit: BoxFit.cover)
                  : Image.file(File(imagePath),
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset("assets/images/default.webp")),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text(description,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Text("$rating",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(" ($reviews)", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text("\$$price",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
