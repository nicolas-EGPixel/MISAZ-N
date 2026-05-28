import 'package:flutter/material.dart';

class FavoritosPage extends StatefulWidget {
  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage>
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
    return Column(
      children: [
        // Título
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Mis Favoritos",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),

        // Tabs
        TabBar(
          controller: _tabController,
          labelColor: Colors.deepOrange,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.deepOrange,
          tabs: const [
            Tab(text: "Comida"),
            Tab(text: "Negocios"),
          ],
        ),

        // Contenido de cada tab
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _emptyList("Aún no tienes comidas favoritas 🍕"),
              _emptyList("Aún no tienes negocios favoritos 🏪"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _emptyList(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
      ),
    );
  }
}
