import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert'; // 👈 Para procesar el JSON de la API
import 'package:http/http.dart' as http; // 👈 Para consumir la API
import 'compras.dart'; 
import '../base_de_datos/db_helper.dart'; 

class FoodDetailPage extends StatefulWidget {
  final int id; 
  final String userEmail; 
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
  late Future<List<dynamic>> _futureResenas; // 👈 Futuro que controlará el FutureBuilder

  @override
  void initState() {
    super.initState();
    _comprobarSiEsFavorito();
    _futureResenas = _obtenerResenasAleatorias(); // 👈 Inicializamos la petición al cargar
  }

  // 🔸 NUEVO MÉTODO: Consumo de la API Externa para Reseñas
  Future<List<dynamic>> _obtenerResenasAleatorias() async {
    try {
      // Pedimos 3 usuarios aleatorios a la API
      final url = Uri.parse('https://randomuser.me/api/?results=3&nat=mx,us,es');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results']; // Devuelve la lista de usuarios con sus datos
      } else {
        throw Exception('Error al cargar reseñas');
      }
    } catch (e) {
      // Si no hay internet o falla la API, devolvemos una lista vacía para que no rompa la app
      return [];
    }
  }

  Future<void> _comprobarSiEsFavorito() async {
    bool fav = await DBHelper.esFavorito(widget.userEmail, widget.id);
    setState(() {
      _isFavorite = fav;
    });
  }

  Future<void> _toggleFavorite() async {
    await DBHelper.alternarFavorito(widget.userEmail, widget.id);
    _comprobarSiEsFavorito();
  }

  // Comentarios estáticos o predefinidos para asignar a los usuarios de la API
  final List<String> _comentariosSimulados = [
    "¡Excelente servicio! La comida llegó súper caliente y el sabor es increíble.",
    "Muy buena calidad y las porciones son bastante generosas. Volveré a pedir.",
    "El sazón es verdaderamente casero, 100% recomendado para quitar el antojo."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Imagen del Platillo
            widget.imagePath.startsWith("assets")
                ? Image.asset(widget.imagePath, width: double.infinity, height: 250, fit: BoxFit.cover)
                : Image.file(File(widget.imagePath), width: double.infinity, height: 250, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(height: 250, color: Colors.grey[300], child: const Icon(Icons.fastfood, size: 80))),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      Text(" ${widget.rating} (${widget.reviews} reseñas)", style: const TextStyle(fontSize: 16)),
                      const Spacer(),
                      Text("\$${widget.price.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(widget.description, style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                  const SizedBox(height: 24),

                  // Botones de acción
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PurchaseFormPage(
                                userEmail: widget.userEmail,
                                platillo: widget.title,
                                precio: widget.price,
                                imagePath: widget.imagePath,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.shopping_cart, color: Colors.white),
                        label: const Text("Comprar ahora", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                      ),
                      const Spacer(),
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
                  const Text("Reseñas de Clientes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(),

                  // 🔸 SECCIÓN DINÁMICA CON FUTUREBUILDER (Punto 5 de la rúbrica)
                  FutureBuilder<List<dynamic>>(
                    future: _futureResenas,
                    builder: (context, snapshot) {
                      // 1. Estado de Carga (Círculo de progreso visual de red)
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator(color: Colors.deepOrange)),
                        );
                      }
                      
                      // 2. Control de errores o si la lista regresó vacía (Sin internet)
                      if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                        return const ListTile(
                          leading: Icon(Icons.person, color: Colors.grey),
                          title: Text("Reseñas no disponibles por el momento"),
                          subtitle: Text("Conéctate a internet para ver las opiniones en vivo."),
                        );
                      }

                      // 3. Renderizado exitoso de los datos obtenidos de la API
                      final usuarios = snapshot.data!;
                      return Column(
                        children: List.generate(usuarios.length, (index) {
                          final usuario = usuarios[index];
                          final nombreCompleto = "${usuario['name']['first']} ${usuario['name']['last']}";
                          final urlFoto = usuario['picture']['medium'];
                          
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            elevation: 0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(urlFoto), // 👈 Carga la foto desde internet de forma nativa
                              ),
                              title: Text(nombreCompleto, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(_comentariosSimulados[index % _comentariosSimulados.length]),
                            ),
                          );
                        }),
                      );
                    },
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