import 'package:flutter/material.dart';
import 'mapa.dart';
import 'favoritos.dart';
import 'perfil.dart';
import 'entregas.dart';
import 'food_detail_page.dart';

// 🔸 Páginas extra
class PublicarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Aquí podrás publicar tus productos 🛒",
          style: TextStyle(fontSize: 18)),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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

  final List<Map<String, dynamic>> foods = [
    {
      "title": "Pizza Margarita",
      "description": "Pizza clásica con tomate, mozzarella y albahaca fresca.",
      "image": "assets/images/pizza.webp",
      "rating": 4.5,
      "reviews": 128,
      "price": 12.99,
    },
    {
      "title": "Hamburguesa BBQ",
      "description": "Carne angus, cheddar, bacon y salsa BBQ.",
      "image": "assets/images/burger.webp",
      "rating": 4.7,
      "reviews": 89,
      "price": 10.50,
    },
    {
      "title": "Tacos Variado",
      "description": "Selección de 24 piezas premium.",
      "image": "assets/images/tacos.webp",
      "rating": 4.8,
      "reviews": 256,
      "price": 24.99,
    },
  ];

  late List<Widget> _pages;
  late List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    _pages = [
      _inicioPage(),   // Inicio
      MapaPage(),      // Mapa
      FavoritosPage(), // Favoritos
      PerfilPage(onRoleSelected: _addRolePage), // Perfil con callback
    ];

    _navItems = const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
      BottomNavigationBarItem(icon: Icon(Icons.map), label: "Mapa"),
      BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favoritos"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
    ];
  }

  // 🔸 Callback desde PerfilPage
  void _addRolePage(String role) {
    setState(() {
      if (role == "publicar") {
        _pages.insert(3, PublicarPage());
        _navItems = [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          const BottomNavigationBarItem(icon: Icon(Icons.map), label: "Mapa"),
          const BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favoritos"),
          const BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Publicar"),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ];
      } else if (role == "entregas") {
        _pages.insert(3, EntregasPage());
        _navItems = [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          const BottomNavigationBarItem(icon: Icon(Icons.map), label: "Mapa"),
          const BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favoritos"),
          const BottomNavigationBarItem(icon: Icon(Icons.delivery_dining), label: "Entregas"),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          _selectedIndex == 0
              ? "¡Hola! ¿Qué quieres comer hoy?"
              : _selectedIndex == 1
                  ? "Mapa"
                  : _selectedIndex == 2
                      ? "Mis Favoritos"
                      : _selectedIndex == 3 && _navItems[3].label == "Publicar"
                          ? "Publicar"
                          : _selectedIndex == 3 && _navItems[3].label == "Entregas"
                              ? "Entregas"
                              : "Perfil",
        ),
      ),
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: _navItems,
      ),
    );
  }

  // Página de inicio con categorías y recomendaciones
  Widget _inicioPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          Text("Recomendaciones",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 15),

          Column(
            children: foods.map((food) {
              return _foodCard(
                food["title"],
                food["description"],
                food["image"],
                food["rating"],
                food["reviews"],
                food["price"],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  // Tarjeta de comida
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
              child: Image.asset(imagePath,
                  height: 160, width: double.infinity, fit: BoxFit.cover),
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
                  Text("€$price",
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

