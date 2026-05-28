import 'package:flutter/material.dart';
import 'home_page.dart';
import 'custom_input.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50, // 🔸 Fondo general
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Encabezado con color y texto
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: Colors.deepOrange, // 🔸 Fondo naranja
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40), // 🔸 Bordes redondeados
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.restaurant_menu, size: 80, color: Colors.white), // 🔸 Ícono blanco
                  SizedBox(height: 10),
                  Text(
                    "Crear Cuenta",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // 🔸 Texto blanco
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Únete a Mi Sazón 🍲",
                    style: TextStyle(color: Colors.white70, fontSize: 16), // 🔸 Texto secundario
                  ),
                ],
              ),
            ),

            // Formulario
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  CustomInput(controller: nameController, label: "Nombre completo"),
                  SizedBox(height: 15),
                  CustomInput(controller: emailController, label: "Correo electrónico"),
                  SizedBox(height: 15),
                  CustomInput(controller: passwordController, label: "Contraseña", obscure: true),
                  SizedBox(height: 25),

                  // Botón estilizado
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.deepOrange, // 🔸 Fondo naranja
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // 🔸 Bordes redondeados
                      ),
                      elevation: 4, // 🔸 Sombra
                    ),
                    child: Text(
                      "Registrarse",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // ✅ Texto blanco
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => HomePage()),
                      );
                    },
                  ),

                  SizedBox(height: 20),

                  // Link para volver al login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("¿Ya tienes cuenta? ",
                          style: TextStyle(color: Colors.grey[700])),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Inicia sesión",
                          style: TextStyle(
                            color: Colors.deepOrange, // 🔸 Texto naranja
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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