import 'package:flutter/material.dart';
import 'dart:io';
import 'compras.dart'; 
import '../base_de_datos/db_helper.dart'; // 👈 Importamos la BD

class FoodDetailPage extends StatefulWidget {
  final int id; // 🔸 Recibimos el ID del platillo
  final String userEmail; // 🔸 Recibimos el email del usuario logueado
  final String title;
  final String description;
  final String imagePath;
  final double rating;
  final int reviews;
  final double price;
  final String? categoria; 

  FoodDetailPage({
    required this.id,
    required this.userEmail,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.rating,
    required this.reviews,
    required this.price,
    this.categoria,
  });

  @override
  _FoodDetailPageState createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _comprobarSiEsFavorito();
  }

  // Comprobamos al iniciar la pantalla si este platillo ya tiene el corazón marcado
  Future<void> _comprobarSiEsFavorito() async {
    bool fav = await DBHelper.esFavorito(widget.userEmail, widget.id);
    setState(() {
      _isFavorite = fav;
    });
  }

  // Método al presionar el corazón
  Future<void> _toggleFavorite() async {
    await DBHelper.alternarFavorito(widget.userEmail, widget.id);
    setState(() {
      _isFavorite = !_isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? "¡Añadido a favoritos! ❤️" : "Eliminado de favoritos 💔"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen segura (assets o archivo local)
            widget.imagePath.startsWith("assets")
                ? Image.asset(
                    widget.imagePath,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(widget.imagePath),
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 220,
                        color: Colors.grey[300],
                        child: const Icon(Icons.fastfood, size: 50, color: Colors.grey),
                      );
                    },
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.description, style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      Text("${widget.rating} (${widget.reviews} reseñas)", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text("\$${widget.price}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                  const SizedBox(height: 20),
                  
                  // Fila de botones de acción
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PurchaseFormPage(
                                platillo: widget.title,
                                precio: widget.price,
                                imagePath: widget.imagePath,
                                userEmail: widget.userEmail,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text("Comprar ahora"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                      ),
                      const Spacer(),
                      
                      // 🔸 ICONO DE CORAZÓN INTERACTIVO ACTUALIZADO
                      IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.deepOrange,
                          size: 30,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text("Reseñas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(),
                  const ListTile(
                    leading: Icon(Icons.person),
                    title: Text("María García"),
                    subtitle: Text("¡Excelente! La mejor pizza que he probado."),
                  ),
                  const ListTile(
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