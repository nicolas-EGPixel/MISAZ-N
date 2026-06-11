import 'package:flutter/material.dart';
import 'mapa.dart';
import 'favoritos.dart';
import 'perfil.dart';
import 'food_detail_page.dart';
import 'entregas.dart';
import 'publicar.dart';
import '../base_de_datos/db_helper.dart';
import 'dart:io';

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

  String? _categoriaSeleccionada; // categoría activa

  final List<Map<String, dynamic>> categories = [
    {"icon": Icons.local_pizza, "label": "Pizzas"},
    {"icon": Icons.fastfood, "label": "Hamburguesas"},
    {"icon": Icons.local_dining, "label": "Tacos"},
    {"icon": Icons.eco, "label": "Ensaladas"},
    {"icon": Icons.set_meal, "label": "Pasta"},
    {"icon": Icons.cake, "label": "Postres"},
    {"icon": Icons.local_drink, "label": "Bebidas"},
    {"icon": Icons.rice_bowl, "label": "Otros"},
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
      _esRepartidor = repartidor != null;
    });
  }

  void _cargarPlatillos() async {
    final data = await DBHelper.getPlatillos();
    setState(() {
      platillos = data;
    });
  }

  void _ejecutarBusqueda(String texto) async {
    if (texto.isEmpty) {
      _cargarPlatillos();
    } else {
      final resultados = await DBHelper.buscarPlatillos(texto);
      setState(() {
        platillos = resultados;
        _categoriaSeleccionada = null; // reset categoría si se busca
      });
    }
  }

  void _filtrarPorCategoria(String categoria) async {
    if (_categoriaSeleccionada == categoria) {
      _cargarPlatillos(); // reset si se vuelve a tocar
      setState(() {
        _categoriaSeleccionada = null;
      });
    } else {
      final dbPlatillos = await DBHelper.getPlatillos();
      final filtrados = dbPlatillos.where((p) => p["categoria"] == categoria).toList();
      setState(() {
        platillos = filtrados;
        _categoriaSeleccionada = categoria;
      });
    }
  }

  List<Widget> _obtenerPaginas() {
    return [
      _inicioPage(),
      MapaPage(usuario: widget.usuario),
      if (_esVendedor) PublicarPage(usuario: widget.usuario),
      if (_esRepartidor) EntregasPage(usuario: widget.usuario),
      FavoritosPage(usuario: widget.usuario),
      PerfilPage(
        usuario: widget.usuario,
        onRoleSelected: (String role) {
          _verificarRolVendedor();
          _verificarRolRepartidor();
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
        const BottomNavigationBarItem(icon: Icon(Icons.delivery_dining), label: "Entregas"),
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
            onChanged: (value) => _ejecutarBusqueda(value),
            decoration: InputDecoration(
              hintText: "Buscar alimentos...",
              prefixIcon: const Icon(Icons.search),
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
              final isSelected = _categoriaSeleccionada == item["label"];

              return GestureDetector(
                onTap: () => _filtrarPorCategoria(item["label"]),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: isSelected ? Colors.deepOrange : Colors.deepOrange.shade100,
                      child: Icon(item["icon"], size: 28, color: isSelected ? Colors.white : Colors.deepOrange),
                    ),
                    SizedBox(height: 6),
                    Text(
                      item["label"],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.deepOrange : Colors.black,
                      ),
                    ),
                  ],
                ),
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
                      p["id"] ?? 0,
                      p["nombre_platillo"],
                      p["descripcion"],
                      p["imagen"],
                      4.5,
                      128,
                      p["precio"] is int ? (p["precio"] as int).toDouble() : p["precio"],
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _foodCard(int id, String title, String description, String imagePath,
      double rating, int reviews, double price) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailPage(
              id: id,
              userEmail: widget.usuario['gmail'] ?? "",
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
              child: Image.file(
                File(imagePath),
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
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
                  style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
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
