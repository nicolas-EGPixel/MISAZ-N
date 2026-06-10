import 'package:flutter/material.dart';
import '../base_de_datos/db_helper.dart';

class HistorialComprasPage extends StatefulWidget {
  final Map<String, dynamic> usuario;

  HistorialComprasPage({required this.usuario});

  @override
  _HistorialComprasPageState createState() => _HistorialComprasPageState();
}

class _HistorialComprasPageState extends State<HistorialComprasPage> {
  List<Map<String, dynamic>> _historial = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
  }

  Future<void> _cargarHistorial() async {
    String email = widget.usuario['gmail'] ?? "";
    if (email.isNotEmpty) {
      // 💡 Aquí llamas a tu consulta personalizada de SQLite en DBHelper
      // Por ejemplo: DBHelper.obtenerPedidosPorUsuario(email)
      final compras = await DBHelper.obtenerPedidosPorUsuario(email);
      setState(() {
        _historial = compras;
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text("Historial de Compras", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator(color: Colors.deepOrange))
          : _historial.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history_toggle_off, size: 60, color: Colors.grey),
                      SizedBox(height: 10),
                      Text("Aún no has realizado compras.",
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _historial.length,
                  itemBuilder: (context, index) {
                    final compra = _historial[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepOrange.shade100,
                          child: const Icon(Icons.fastfood, color: Colors.deepOrange),
                        ),
                        title: Text(
                          "${compra['nombre_platillo']} (x${compra['cantidad']})",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text("Dirección: ${compra['direccion']}"),
                            Text(
                              "Total pago: \$${compra['total']}",
                              style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        trailing: const Chip(
                          label: Text("Pedido", style: TextStyle(color: Colors.white, fontSize: 11)),
                          backgroundColor: Colors.green,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}