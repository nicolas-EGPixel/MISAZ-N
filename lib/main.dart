import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 253, 252, 198),
        appBar: AppBar(
          title: const Text("Mi primera aplicación en Flutter"),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 5, 104, 96),
          titleTextStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          elevation: 4,
          toolbarHeight: 75,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Color.fromARGB(255, 115, 255, 255), size: 30),
            onPressed: () {
              print("Se ha presionado el botón del menú");
            },
          ),

          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white, size: 30),
              onPressed: () {
                print("Se ha presionado el botón de búsqueda");
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.white, size: 30),
              onPressed: () {
                print("Se ha presionado el botón del perfil");
              },
            ),
          ],
        ),

        body:
        Column(
          mainAxisAlignment: MainAxisAlignment.center, //Esto obliga a que el bloque (la columna) se quede en la pocisión indicada, hasta abajo
          children: [
         const Center(
          child: Text(
            "Esta es mi primera APP\nen el framework de Flutter",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        Image.asset("assets/images/mdzs.jpg", width: 200, height: 200),
        ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end, //Esto obliga a que el bloque (la columna) se quede en la pocisión indicada, hasta abajo
          children: [
            FloatingActionButton(
              heroTag: "Botón 1",
              backgroundColor: const Color.fromARGB(255, 5, 104, 96),
              onPressed: () { 
                print("Se ha preadionado el botón flotante 1"); 
              },
              child: Icon(Icons.add, color: Colors.white, size: 30),
            ),

            FloatingActionButton(
              heroTag: "Botón 2",
              backgroundColor: const Color.fromARGB(255, 5, 104, 96),
              onPressed: () { 
                print("Se ha preadionado el botón flotante 2"); 
              },
              child: Icon(Icons.location_on, color: Colors.white, size: 30),
            ),

            FloatingActionButton(
              heroTag: "Botón 3",
              backgroundColor: const Color.fromARGB(255, 5, 104, 96),
              onPressed: () { 
                print("Se ha preadionado el botón flotante 3"); 
              },
              child: Icon(Icons.share, color: Colors.white, size: 30),
            ),
          ],
        ),

      ),
    ),
  );
}