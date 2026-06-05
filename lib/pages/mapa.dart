import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Librería del maestro
import 'package:latlong2/latlong.dart'; // Librería para manejar coordenadas

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  late GoogleMapController _mapController;

  // Coordenadas de Zamora, Michoacán
  final LatLng zamoraCenter = LatLng(19.9833, -102.2833);

  // Lista de establecimientos cercanos (por ahora vacía)
  final List<Map<String, dynamic>> establecimientos = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Encabezado con buscador
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Encuentra tu restaurante",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: "Buscar establecimientos...",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Sección del mapa
        Expanded(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.all(12), // 🔸 Bordes alrededor del mapa
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: zamoraCenter,
                      zoom: 14,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false, // 🔸 Desactivamos el botón default
                  ),
                ),
              ),

              // Botones flotantes sobre el mapa
              Positioned(
                bottom: 20,
                right: 20,
                child: Column(
                  children: [
                    FloatingActionButton(
                      heroTag: "location",
                      backgroundColor: Colors.deepOrange,
                      child: Icon(Icons.my_location, color: Colors.white),
                      onPressed: () {
                        _mapController.animateCamera(
                          CameraUpdate.newLatLng(zamoraCenter),
                        );
                      },
                    ),
                    SizedBox(height: 12),
                    FloatingActionButton(
                      heroTag: "fullscreen",
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.fullscreen, color: Colors.white),
                      onPressed: () {
                        // Aquí podrías abrir un modal con el mapa en pantalla completa
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Establecimientos cercanos
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Establecimientos cercanos",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              establecimientos.isEmpty
                  ? Text("No hay establecimientos registrados aún.",
                      style: TextStyle(color: Colors.grey[600]))
                  : Column(
                      children: establecimientos.map((e) {
                        return ListTile(
                          leading: Icon(Icons.store, color: Colors.deepOrange),
                          title: Text(e["nombre"]),
                          subtitle: Text(e["direccion"]),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}