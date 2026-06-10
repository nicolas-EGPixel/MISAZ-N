import 'package:flutter/material.dart';
import '../base_de_datos/db_helper.dart';
import 'food_detail_page.dart';
import 'negocio_tarjeta.dart';
import 'dart:io';

class FavoritosPage extends StatefulWidget {
  final Map<String, dynamic> usuario;

  FavoritosPage({required this.usuario});

  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _comidasFavoritas = [];
  List<Map<String, dynamic>> _negociosFavoritos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _cargarFavoritos();
  }

  Future<void> _cargarFavoritos() async {
    setState(() => _cargando = true);
    String email = widget.usuario['gmail'] ?? "";
    if (email.isNotEmpty) {
      final favComidas = await DBHelper.obtenerPlatillosFavoritos(email);
      final favNegocios = await DBHelper.obtenerNegociosFavoritos(email);
      setState(() {
        _comidasFavoritas = favComidas;
        _negociosFavoritos = favNegocios;
        _cargando = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            "Mis Favoritos",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange),
          ),
        ),

        TabBar(
          controller: _tabController,
          labelColor: Colors.deepOrange,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.deepOrange,
          tabs: const [
            Tab(text: "Comida"),
            Tab(text: "Negocios"),
          ],
        ),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // --- PESTAÑA 1: COMIDA ---
              _cargando
                  ? const Center(child: CircularProgressIndicator(color: Colors.deepOrange))
                  : _comidasFavoritas.isEmpty
                      ? _emptyList("Aún no tienes comidas favoritas 🍕")
                      : ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: _comidasFavoritas.length,
                          itemBuilder: (context, index) {
                            final platillo = _comidasFavoritas[index];
                            final imagen = platillo['imagen'] ?? "";

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 2,
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: imagen.startsWith("assets")
                                      ? Image.asset(imagen, width: 60, height: 60, fit: BoxFit.cover)
                                      : Image.file(File(imagen), width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.fastfood, size: 40)),
                                ),
                                title: Text(platillo['nombre_platillo'] ?? "Platillo", style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text("\$${platillo['precio']}", style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w600)),
                                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FoodDetailPage(
                                        id: platillo['id'],
                                        userEmail: widget.usuario['gmail'],
                                        title: platillo['nombre_platillo'],
                                        description: platillo['descripcion'] ?? "",
                                        imagePath: imagen,
                                        rating: 4.5,
                                        reviews: 12,
                                        price: (platillo['precio'] as num).toDouble(),
                                        categoria: platillo['categoria'],
                                      ),
                                    ),
                                  );
                                  _cargarFavoritos();
                                },
                              ),
                            );
                          },
                        ),

              // --- PESTAÑA 2: NEGOCIOS ---
              _cargando
                  ? const Center(child: CircularProgressIndicator(color: Colors.deepOrange))
                  : _negociosFavoritos.isEmpty
                      ? _emptyList("Aún no tienes negocios favoritos 🏪")
                      : ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: _negociosFavoritos.length,
                          itemBuilder: (context, index) {
                            final negocio = _negociosFavoritos[index];
                            return NegocioTarjeta(
                              idNegocio: negocio['id'],
                              nombreNegocio: negocio['nombre_negocio'],
                              tipoNegocio: negocio['tipo_negocio'],
                              direccion: negocio['direccion'],
                              telefono: negocio['telefono'],
                              fotoNegocio: negocio['foto_negocio'] ?? "assets/images/default.webp",
                              gmailUsuario: widget.usuario['gmail'],
                            );
                          },
                        ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _emptyList(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
