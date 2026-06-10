import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../base_de_datos/db_helper.dart';

class EvaluacionVendedorPage extends StatefulWidget {
  final Map<String, dynamic> usuario; // Recibe datos del usuario
  final Function(String) onRoleSelected; // Callback para HomePage

  EvaluacionVendedorPage({required this.usuario, required this.onRoleSelected});

  @override
  _EvaluacionVendedorPageState createState() => _EvaluacionVendedorPageState();
}

class _EvaluacionVendedorPageState extends State<EvaluacionVendedorPage> {
  // Controladores exclusivos de esta pantalla
  final TextEditingController nombreNegocioController = TextEditingController();
  final TextEditingController tipoNegocioController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController horariosController = TextEditingController();

  // Foto del negocio
  File? _fotoNegocio;
  final ImagePicker _picker = ImagePicker();

  Future<void> _seleccionarFoto() async {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() {
        _fotoNegocio = File(imagen.path);
      });
    }
  }

  // Criterios de evaluación
  bool _aceptaHigiene = false;
  bool _aceptaTiempos = false;
  bool _aceptaTerminos = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text("Currículum de Vendedor", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Danos detalles de tu negocio",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const SizedBox(height: 10),
            const Text("Te garantizamos la calidad de Sazón de Hogar. Necesitamos conocer tu servicio."),
            const SizedBox(height: 25),

            // FORMULARIO DETALLADO (Datos obligatorios *)
            _crearCampo("Nombre completo de tu cocina/negocio *", nombreNegocioController, Icons.store),
            _crearCampo("Especialidad (Ej. Casera, Tacos, Postres) *", tipoNegocioController, Icons.restaurant_menu),
            _crearCampo("Dirección de preparación exacta *", direccionController, Icons.location_on),
            _crearCampo("Teléfono de contacto (WhatsApp) *", telefonoController, Icons.phone, isNumber: true),
            _crearCampo("Días y horarios de disponibilidad *", horariosController, Icons.access_time),

            const SizedBox(height: 20),
            const Text("Foto del negocio", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: _seleccionarFoto,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _fotoNegocio == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_a_photo, size: 40, color: Colors.deepOrange),
                            SizedBox(height: 8),
                            Text("Click para subir foto del negocio"),
                          ],
                        ),
                      )
                    : Image.file(_fotoNegocio!, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 25),
            const Text("Criterios de Calidad de Mi Sazón", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            CheckboxListTile(
              activeColor: Colors.deepOrange,
              title: const Text("Acepto seguir medidas estrictas de higiene en la preparación de alimentos."),
              value: _aceptaHigiene,
              onChanged: (val) => setState(() => _aceptaHigiene = val!),
            ),
            CheckboxListTile(
              activeColor: Colors.deepOrange,
              title: const Text("Me comprometo a cumplir con los tiempos de entrega estimados."),
              value: _aceptaTiempos,
              onChanged: (val) => setState(() => _aceptaTiempos = val!),
            ),
            CheckboxListTile(
              activeColor: Colors.deepOrange,
              title: const Text("Entiendo que la plataforma cobrará una comisión fija por platillo vendido."),
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
                child: const Text("Confirmar Evaluación", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () async {
                  if (nombreNegocioController.text.isEmpty || tipoNegocioController.text.isEmpty || direccionController.text.isEmpty || telefonoController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Por favor llena los campos obligatorios (*)")));
                    return;
                  }
                  if (_fotoNegocio == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Debes subir una foto del negocio")));
                    return;
                  }
                  if (!_aceptaHigiene || !_aceptaTiempos || !_aceptaTerminos) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Debes aceptar todos los criterios de calidad")));
                    return;
                  }

                  try {
                    // Guardamos la información core en la BD (tb_negocios)
                    await DBHelper.registrarNegocio(
                      widget.usuario['gmail'] ?? "",
                      nombreNegocioController.text,
                      tipoNegocioController.text,
                      direccionController.text,
                      telefonoController.text,
                      _fotoNegocio!.path, // guardamos la foto del negocio
                    );

                    widget.onRoleSelected("vendedor");
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("¡Evaluación exitosa! Ya puedes publicar tus platillos."), backgroundColor: Colors.green),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al registrar negocio: $e")));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

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
