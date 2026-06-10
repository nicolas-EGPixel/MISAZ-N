import 'dart:io';
import 'package:flutter/material.dart';
import '../base_de_datos/db_helper.dart';

class NegocioTarjeta extends StatefulWidget {
  final int idNegocio;
  final String nombreNegocio;
  final String tipoNegocio;
  final String direccion;
  final String telefono;
  final String fotoNegocio;
  final String gmailUsuario; // 👈 para saber quién está logueado

  const NegocioTarjeta({
    Key? key,
    required this.idNegocio,
    required this.nombreNegocio,
    required this.tipoNegocio,
    required this.direccion,
    required this.telefono,
    required this.fotoNegocio,
    required this.gmailUsuario,
  }) : super(key: key);

  @override
  _NegocioTarjetaState createState() => _NegocioTarjetaState();
}

class _NegocioTarjetaState extends State<NegocioTarjeta> {
  bool _esFavorito = false;

  @override
  void initState() {
    super.initState();
    _verificarFavorito();
  }

  Future<void> _verificarFavorito() async {
    final esFav = await DBHelper.esFavorito(widget.gmailUsuario, widget.idNegocio);
    setState(() {
      _esFavorito = esFav;
    });
  }

  Future<void> _toggleFavorito() async {
    await DBHelper.alternarFavorito(widget.gmailUsuario, widget.idNegocio);
    _verificarFavorito();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del negocio
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: widget.fotoNegocio.toString().startsWith("assets")
                ? Image.asset(widget.fotoNegocio,
                    height: 160, width: double.infinity, fit: BoxFit.cover)
                : Image.file(File(widget.fotoNegocio),
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset("assets/images/default.webp")),
          ),
          // Información + botón de favoritos
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info negocio
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.nombreNegocio,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(widget.tipoNegocio,
                          style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: Colors.deepOrange),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(widget.direccion,
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.phone,
                              size: 16, color: Colors.deepOrange),
                          const SizedBox(width: 4),
                          Text(widget.telefono,
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Botón de favoritos
                IconButton(
                  icon: Icon(
                    _esFavorito ? Icons.favorite : Icons.favorite_border,
                    color: Colors.deepOrange,
                  ),
                  onPressed: _toggleFavorito,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
