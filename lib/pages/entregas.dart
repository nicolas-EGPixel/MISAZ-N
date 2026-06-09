import 'package:flutter/material.dart';
import '../base_de_datos/db_helper.dart';

class EntregasPage extends StatefulWidget {
  final Map<String, dynamic> usuario;

  EntregasPage({required this.usuario});

  @override
  _EntregasPageState createState() => _EntregasPageState();
}

class _EntregasPageState extends State<EntregasPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _pedidos = [];
  List<Map<String, dynamic>> _completados = [];
  Set<int> _aceptados = {}; // IDs de pedidos aceptados

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _cargarPedidos();
    _cargarCompletados();
  }

  Future<void> _cargarPedidos() async {
    final pedidos = await DBHelper.obtenerPedidos();
    setState(() {
      _pedidos = pedidos;
    });
  }

  Future<void> _cargarCompletados() async {
    final completados = await DBHelper.obtenerCompletados();
    setState(() {
      _completados = completados;
    });
  }

  void _aceptarPedido(Map<String, dynamic> pedido) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar aceptación"),
        content: const Text(
            "¿Estás seguro de aceptar la orden?\nRecuerda que debes entregarla en tiempo y forma, si no se te sancionará."),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Aceptar", style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _aceptados.add(pedido['id']); // marcar como aceptado
              });
            },
          ),
        ],
      ),
    );
  }

  void _confirmarEntrega(Map<String, dynamic> pedido) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar entrega"),
        content: const Text("¿Ya fue entregado el producto al cliente?"),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Sí, entregado",
                style: TextStyle(color: Colors.white)),
            onPressed: () async {
              Navigator.pop(context);

              // 1. Insertar en tb_completados
              await DBHelper.registrarCompletado(
                pedido['nombre_platillo'],
                pedido['cantidad'],
                pedido['direccion'],
                pedido['envio'],
              );

              // 2. Eliminar de tb_pedidos
              await DBHelper.eliminarPedido(pedido['id']);

              // 3. Recargar listas
              await _cargarPedidos();
              await _cargarCompletados();

              setState(() {
                _aceptados.remove(pedido['id']);
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Mis entregas",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Gestiona tus pedidos como repartidor",
                style: TextStyle(fontSize: 14)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: "Solicitudes (${_pedidos.length})"),
            Tab(text: "Completados (${_completados.length})"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 🔹 Solicitudes
          _pedidos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.access_time, size: 60, color: Colors.grey),
                      SizedBox(height: 10),
                      Text("No hay solicitudes pendientes",
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _pedidos.length,
                  itemBuilder: (context, index) {
                    final pedido = _pedidos[index];
                    final aceptado = _aceptados.contains(pedido['id']);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${pedido['nombre_platillo']} (x${pedido['cantidad']})",
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange)),
                            const SizedBox(height: 6),
                            Text("Dirección: ${pedido['direccion']}"),
                            Text("Teléfono: ${pedido['telefono']}"),
                            if ((pedido['notas'] ?? "").isNotEmpty)
                              Text("Notas: ${pedido['notas']}",
                                  style: const TextStyle(color: Colors.grey)),
                            const Divider(),
                            Text("Subtotal: \$${pedido['subtotal']}"),
                            Text("Envío: \$${pedido['envio']}"),
                            Text("Total: \$${pedido['total']}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange)),
                            const SizedBox(height: 10),

                            // Botones dinámicos
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: aceptado
                                  ? [
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.blue,
                                        ),
                                        onPressed: () {
                                          // Aquí podrías abrir el marcador telefónico
                                        },
                                        icon: const Icon(Icons.phone),
                                        label: const Text("Llamar"),
                                      ),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          _confirmarEntrega(pedido);
                                        },
                                        icon: const Icon(Icons.check),
                                        label: const Text("¿Ya está entregado?",
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ),
                                    ]
                                  : [
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueGrey,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          // Abrir mapa
                                        },
                                        icon: const Icon(Icons.map),
                                        label: const Text("Ver mapa",
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          _aceptarPedido(pedido);
                                        },
                                        icon: const Icon(Icons.check),
                                        label: const Text("Aceptar pedido",
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ),
                                    ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),

          // 🔹 Completados
          _completados.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check_circle, size: 60, color: Colors.green),
                      SizedBox(height: 10),
                      Text("No hay entregas completadas",
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _completados.length,
                  itemBuilder: (context, index) {
                    final pedido = _completados[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(Icons.check_circle,
                            color: Colors.green),
                        title: Text("${pedido['nombre_platillo']} (x${pedido['cantidad']})"),
                        subtitle: Text(
                            "Dirección: ${pedido['direccion']}\nGanancia: \$${pedido['envio']}"),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}