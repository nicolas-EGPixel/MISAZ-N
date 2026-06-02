import 'package:flutter/material.dart';

class EntregasPage extends StatefulWidget {
  @override
  _EntregasPageState createState() => _EntregasPageState();
}

class _EntregasPageState extends State<EntregasPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: Column(
        children: [
          // 🔸 Encabezado con gradiente y título
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "Mis entregas",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 10),
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: [
                    Tab(text: "Solicitudes (0)"),
                    Tab(text: "Completados (2)"),
                  ],
                ),
              ],
            ),
          ),

          // 🔸 Contenido de las pestañas
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Solicitudes
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time,
                          size: 60, color: Colors.deepOrange),
                      SizedBox(height: 10),
                      Text("No hay solicitudes pendientes",
                          style: TextStyle(
                              fontSize: 16, color: Colors.grey[700])),
                    ],
                  ),
                ),

                // Completados
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.check_circle,
                            color: Colors.green, size: 30),
                        title: Text("Entrega #1"),
                        subtitle: Text("Pedido completado el 28/05/2026"),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.check_circle,
                            color: Colors.green, size: 30),
                        title: Text("Entrega #2"),
                        subtitle: Text("Pedido completado el 30/05/2026"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
