import 'package:flutter/material.dart';

class FoodDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final double rating;
  final int reviews;
  final double price;

  FoodDetailPage({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.rating,
    required this.reviews,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(imagePath,
                height: 220, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(description,
                      style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      Text("$rating ($reviews reseñas)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("€$price",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Acción de compra
                        },
                        icon: Icon(Icons.shopping_cart),
                        label: Text("Comprar ahora"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite_border,
                            color: Colors.deepOrange),
                        onPressed: () {
                          // Acción de favoritos
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text("Reseñas",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("María García"),
                    subtitle: Text("¡Excelente! La mejor pizza que he probado."),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Carlos Ruiz"),
                    subtitle: Text("Muy buena calidad y sabor."),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
