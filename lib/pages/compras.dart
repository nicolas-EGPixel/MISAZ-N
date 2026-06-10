import 'package:flutter/material.dart';
import 'dart:io';
import '../base_de_datos/db_helper.dart'; // 👈 importa tu DBHelper

class PurchaseFormPage extends StatefulWidget {
  final String userEmail;
  final String platillo;
  final double precio;
  final String imagePath;

  PurchaseFormPage({
    required this.userEmail,
    required this.platillo,
    required this.precio,
    required this.imagePath,
  });

  @override
  _PurchaseFormPageState createState() => _PurchaseFormPageState();
}

class _PurchaseFormPageState extends State<PurchaseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController notasController = TextEditingController();

  int cantidad = 1;
  final double envio = 50.0; // costo fijo de envío

  @override
  Widget build(BuildContext context) {
    double subtotal = widget.precio * cantidad;
    double total = subtotal + envio;

    return Scaffold(
      appBar: AppBar(
        title: Text("Completar pedido"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Imagen del platillo
              widget.imagePath.startsWith("assets")
                  ? Image.asset(widget.imagePath,
                      height: 180, fit: BoxFit.cover)
                  : Image.file(File(widget.imagePath),
                      height: 180, fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset("assets/images/default.webp",
                              height: 180, fit: BoxFit.cover)),

              SizedBox(height: 16),

              // Nombre y precio unitario
              Text(widget.platillo,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text("Precio unitario: \$${widget.precio.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),

              SizedBox(height: 16),

              // Selector de cantidad
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Cantidad:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          if (cantidad > 1) {
                            setState(() {
                              cantidad--;
                            });
                          }
                        },
                      ),
                      Text("$cantidad",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () {
                          setState(() {
                            cantidad++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),

              // Subtotal, envío y total
              SizedBox(height: 10),
              Text("Subtotal: \$${subtotal.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16)),
              Text("Envío: \$${envio.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16)),
              Text("Total: \$${total.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange)),

              SizedBox(height: 20),

              // Dirección
              TextFormField(
                controller: direccionController,
                decoration: InputDecoration(
                  labelText: "Dirección de entrega",
                  prefixIcon: Icon(Icons.home),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Ingrese la dirección" : null,
              ),
              SizedBox(height: 10),

              // Teléfono
              TextFormField(
                controller: telefonoController,
                decoration: InputDecoration(
                  labelText: "Teléfono de contacto",
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value == null || value.isEmpty ? "Ingrese el teléfono" : null,
              ),
              SizedBox(height: 10),

              // Notas adicionales
              TextFormField(
                controller: notasController,
                decoration: InputDecoration(
                  labelText: "Notas adicionales (opcional)",
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              SizedBox(height: 10),

              // Nota semitransparente
              Text(
                "NOTA: El pago es obligatoriamente en efectivo",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.5),
                  fontStyle: FontStyle.italic,
                ),
              ),

              SizedBox(height: 20),

              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade400),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancelar"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        double subtotal = widget.precio * cantidad;
                        double total = subtotal + envio;

                        // 👇 Guardar en la BD
                        await DBHelper.registrarPedido(
                          widget.userEmail,
                          widget.platillo,
                          cantidad,
                          direccionController.text,
                          telefonoController.text,
                          notasController.text,
                          subtotal,
                          envio,
                          total,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(
                              "Pedido confirmado: $cantidad x ${widget.platillo} | Total: \$${total.toStringAsFixed(2)} (Pago en efectivo)")),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Confirmar pedido"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
