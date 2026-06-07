import 'package:flutter/material.dart';
import 'dart:io';

class FoodDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final double rating;
  final int reviews;
  final double price;
  final String? categoria; // opcional

  FoodDetailPage({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.rating,
    required this.reviews,
    required this.price,
    this.categoria,
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
            // 🔹 Imagen segura (assets o archivo local)
            imagePath.startsWith("assets")
                ? Image.asset(
                    imagePath,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(imagePath),
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset("assets/images/default.webp",
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover),
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Descripción
                  Text(description,
                      style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                  SizedBox(height: 10),

                  // Rating y reseñas
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      Text("$rating ($reviews reseñas)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Precio
                  Text("\$$price",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange)),
                  SizedBox(height: 10),

                  // Categoría (si existe)
                  if (categoria != null && categoria!.isNotEmpty)
                    Text("Categoría: $categoria",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700])),

                  SizedBox(height: 20),

                  // Botones de acción
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

                  // Reseñas
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
