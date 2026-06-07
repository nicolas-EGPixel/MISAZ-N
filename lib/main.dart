import 'package:flutter/material.dart';
import 'pages/login_page.dart';

// ✅ Importa sqflite_common_ffi
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // ✅ Inicializa FFI para escritorio (Windows/Linux)
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Sazón',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.orange.shade50,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: LoginPage(),
    );
  }
}

//Creo que ya puedo ver la API
