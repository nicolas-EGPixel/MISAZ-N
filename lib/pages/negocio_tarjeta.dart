import 'dart:io';
import 'package:flutter/material.dart';

class NegocioTarjeta extends StatelessWidget {
  final String nombreNegocio;
  final String tipoNegocio;
  final String direccion;
  final String telefono;
  final String fotoNegocio;

  const NegocioTarjeta({
    Key? key,
    required this.nombreNegocio,
    required this.tipoNegocio,
    required this.direccion,
    required this.telefono,
    required this.fotoNegocio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Aquí podrías navegar a una página de detalle del negocio
      },
      child: Container(
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
              child: fotoNegocio.toString().startsWith("assets")
                  ? Image.asset(fotoNegocio,
                      height: 160, width: double.infinity, fit: BoxFit.cover)
                  : Image.file(File(fotoNegocio),
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset("assets/images/default.webp")),
            ),
            // Información del negocio
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nombreNegocio,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(tipoNegocio,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.deepOrange),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(direccion,
                            style: const TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 16, color: Colors.deepOrange),
                      const SizedBox(width: 4),
                      Text(telefono, style: const TextStyle(fontSize: 12)),
                    ],
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
