import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Librería del maestro
import 'package:latlong2/latlong.dart'; // Librería para manejar coordenadas
import '../base_de_datos/db_helper.dart'; // Para obtener negocios desde la base de datos
import 'negocio_tarjeta.dart'; // Tarjeta personalizada para mostrar negocios

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  // Coordenadas céntricas de Zamora, Michoacán
  final LatLng zamoraCenter = const LatLng(19.9845, -102.2865);

  // Lista de establecimientos cercanos para tu app de comida
  final List<Map<String, dynamic>> establecimientos = [
    {"nombre": "Sabor de Hogar (Centro)", "direccion": "C. Cázares #45, Centro"},
    {"nombre": "Antojitos Doña Mary", "direccion": "Av. Juárez Oriente #210"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Encabezado con buscador de Sazón de Hogar
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

        // CONTENEDOR DEL MAPA GRATUITO (OpenStreetMap)
        Expanded(
          child: Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: zamoraCenter, // Centrado en Zamora
                  initialZoom: 14.0,           // Acercamiento inicial
                  minZoom: 12.0,               // 🔒 No permite alejarse más allá de ver la ciudad completa
                  maxZoom: 18.0,               // 🔒 No permite acercarse al nivel de ver los baches de la calle
                  
                  // 🔒 RESTRICCIÓN DE CÁMARA (Límites geográficos para Zamora)
                  cameraConstraint: CameraConstraint.contain(
                    bounds: LatLngBounds(
                      const LatLng(19.9500, -102.3400), // Esquina inferior izquierda (Suroeste de Zamora)
                      const LatLng(20.0200, -102.2300), // Esquina superior derecha (Noreste de Zamora)
                    ),
                  ),
                ),
                children: [
                  // 1. CAPA DEL MAPA
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.misazon.app',
                  ),
                  
                  // 2. CAPA DE MARCADORES
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

              // Botón flotante decorativo encima del mapa (Pantalla completa)
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

        // Sección inferior: Lista de establecimientos locales
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
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: DBHelper.obtenerNegocios(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text("No hay establecimientos registrados aún.",
                  style: TextStyle(color: Colors.grey[600]));
            }

            final negocios = snapshot.data!;
            return ListView.builder(
              itemCount: negocios.length,
              itemBuilder: (context, index) {
                final negocio = negocios[index];
                return NegocioTarjeta(
                  nombreNegocio: negocio['nombre_negocio'],
                  tipoNegocio: negocio['tipo_negocio'],
                  direccion: negocio['direccion'],
                  telefono: negocio['telefono'],
                  fotoNegocio: negocio['foto_negocio'] ?? "assets/images/default.webp",
                );
              },
            );
          },
        ),
      ),
    ],
  ),
)

      ],
    );
  }
}