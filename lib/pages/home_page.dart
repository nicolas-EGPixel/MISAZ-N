import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
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
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _foodCard("Pizza Margarita", "assets/images/pizza.webp"),
                  _foodCard("Hamburguesa BBQ", "assets/images/burger.webp"),
                  _foodCard("Tacos al Pastor", "assets/images/tacos.webp"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _foodCard(String title, String imagePath) {
    return Container(
      width: 140,
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
            child: Image.asset(imagePath, height: 100, width: 140, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}