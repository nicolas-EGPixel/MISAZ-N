import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; 
import 'package:latlong2/latlong.dart'; 
import '../base_de_datos/db_helper.dart'; 
import 'negocio_tarjeta.dart'; 

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final LatLng zamoraCenter = const LatLng(19.9845, -102.2865);

  List<Map<String, dynamic>> _negocios = [];
  String _query = "";

  @override
  void initState() {
    super.initState();
    _cargarNegocios();
  }

  Future<void> _cargarNegocios([String consulta = ""]) async {
    final negocios = consulta.isEmpty
        ? await DBHelper.obtenerNegocios()
        : await DBHelper.buscarNegocios(consulta);

    setState(() {
      _negocios = negocios;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔹 Encabezado con buscador
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Encuentra tu restaurante",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  _query = value;
                  _cargarNegocios(_query);
                },
                decoration: InputDecoration(
                  hintText: "Buscar comida o negocios...",
                  prefixIcon: const Icon(Icons.search, color: Colors.deepOrange),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ],
          ),
        ),

        // 🔹 Contenedor del mapa
        Expanded(
          child: Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: zamoraCenter,
                  initialZoom: 14.0,
                  minZoom: 12.0,
                  maxZoom: 18.0,
                  cameraConstraint: CameraConstraint.contain(
                    bounds: LatLngBounds(
                      const LatLng(19.9500, -102.3400),
                      const LatLng(20.0200, -102.2300),
                    ),
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.misazon.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: zamoraCenter,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  heroTag: "fullscreen_map",
                  backgroundColor: Colors.deepOrange,
                  child: const Icon(Icons.fullscreen, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Vista de mapa expandida")),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // 🔹 Sección inferior: Lista de negocios
        Container(
          height: 220,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Establecimientos cercanos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: _negocios.isEmpty
                    ? Text("No hay establecimientos registrados aún.",
                        style: TextStyle(color: Colors.grey[600]))
                    : ListView.builder(
                        itemCount: _negocios.length,
                        itemBuilder: (context, index) {
                          final negocio = _negocios[index];
                          return NegocioTarjeta(
                            nombreNegocio: negocio['nombre_negocio'],
                            tipoNegocio: negocio['tipo_negocio'],
                            direccion: negocio['direccion'],
                            telefono: negocio['telefono'],
                            fotoNegocio: negocio['foto_negocio'] ?? "assets/images/default.webp",
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
