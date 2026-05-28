import 'package:flutter/material.dart';
import 'perfil_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PerfilPage()),
      );
    }
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        title: Text("¡Hola! ¿Qué quieres comer hoy?"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de búsqueda
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

            // Categorías
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

            // Recomendaciones
            Text("Recomendaciones",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Container(
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _foodCard(
                    "Pizza Margarita",
                    "Pizza clásica con tomate, mozzarella y albahaca fresca.",
                    "assets/images/pizza.webp",
                    4.5,
                    128,
                    12.99,
                  ),
                  _foodCard(
                    "Hamburguesa BBQ",
                    "Carne angus, cheddar, bacon y salsa BBQ.",
                    "assets/images/burger.webp",
                    4.7,
                    89,
                    10.50,
                  ),
                  _foodCard(
                    "Tacos Variado",
                    "Selección de 24 piezas premium.",
                    "assets/images/tacos.webp",
                    4.8, 
                    256, 
                    24.99,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ---------------- BOTTOM NAVIGATION ----------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        onTap: _onNavItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Mapa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favoritos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
      ),
    );
  }

  Widget _foodCard(String title, String description, String imagePath,
      double rating, int reviews, double price) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 12),
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
                height: 90, width: 150, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 4),
                Text(description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Text("$rating",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    Text(" ($reviews)", style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(height: 6),
                Text("€$price",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
