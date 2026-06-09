import 'package:flutter/material.dart';
import '../base_de_datos/db_helper.dart';

class EvaluacionRepartidorPage extends StatefulWidget {
  final Map<String, dynamic> usuario; // Recibe datos del usuario
  final Function(String) onRoleSelected; // Callback para HomePage

  EvaluacionRepartidorPage({required this.usuario, required this.onRoleSelected});

  @override
  _EvaluacionRepartidorPageState createState() => _EvaluacionRepartidorPageState();
}

class _EvaluacionRepartidorPageState extends State<EvaluacionRepartidorPage> {
  final TextEditingController licenciaController = TextEditingController();

  bool _aceptaTiempos = false;
  bool _aceptaTerminos = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text("Formulario de Repartidor", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Únete como repartidor",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const SizedBox(height: 10),
            const Text("Necesitamos tu licencia de conducir para registrarte."),
            const SizedBox(height: 25),

            // Campo obligatorio
            _crearCampo("Número de licencia de conducir *", licenciaController, Icons.credit_card, isNumber: true),

            const SizedBox(height: 25),
            const Text("Compromisos de calidad", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // CHECKBOXES
            CheckboxListTile(
              activeColor: Colors.deepOrange,
              title: const Text("Me comprometo a cumplir con los tiempos de entrega."),
              value: _aceptaTiempos,
              onChanged: (val) => setState(() => _aceptaTiempos = val!),
            ),
            CheckboxListTile(
              activeColor: Colors.deepOrange,
              title: const Text("Entiendo que el pago de los pedidos será en efectivo."),
              value: _aceptaTerminos,
              onChanged: (val) => setState(() => _aceptaTerminos = val!),
            ),

            const SizedBox(height: 30),

            // BOTÓN DE ENVÍO
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Enviar solicitud", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () async {
                  if (licenciaController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Por favor ingresa tu número de licencia")));
                    return;
                  }
                  if (!_aceptaTiempos || !_aceptaTerminos) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Debes aceptar los compromisos de calidad")));
                    return;
                  }

                  try {
                    // Guardamos en la BD (tb_repartidor)
                    await DBHelper.registrarRepartidor(
                      widget.usuario['gmail'] ?? "",
                      licenciaController.text,
                      0, // ordenes iniciales
                      0, // completadas iniciales
                    );

                    // Avisamos al HomePage que ya somos repartidor
                    widget.onRoleSelected("repartidor");

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("¡Solicitud exitosa! Ya eres repartidor."), backgroundColor: Colors.green),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al registrar repartidor: $e")));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Componente reutilizable para campos de texto
  Widget _crearCampo(String label, TextEditingController controller, IconData icon, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.deepOrange),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
