import 'package:flutter/material.dart';
import 'home_page.dart';
import 'custom_input.dart';
import '/base_de_datos/db_helper.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Encabezado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.restaurant_menu, size: 80, color: Colors.white),
                  SizedBox(height: 10),
                  Text("Crear Cuenta",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 5),
                  Text("Únete a Mi Sazón 🍲", style: TextStyle(color: Colors.white70, fontSize: 16)),
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

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                    ),
                    child: Text("Registrarse",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    onPressed: () async {
                      String email = emailController.text.trim();
                      
                      RegExp emailRegExp = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                      );

                      if (nameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Por favor, ingresa tu nombre")),
                        );
                        return;
                      }

                      if (!emailRegExp.hasMatch(email)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Por favor, ingresa un correo válido con '@' y dominio")),
                        );
                        return;
                      }

                      if (passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Por favor, ingresa una contraseña")),
                        );
                        return;
                      }

                      // Si los campos están correctos, procede a registrar en la BD local:
                      try {
                        await DBHelper.insertUsuario(
                          nameController.text,
                          email,
                          passwordController.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Usuario registrado correctamente")),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomePage(usuario: {
                            "nombre": nameController.text,
                            "gmail": email,
                            "contraseña": passwordController.text,
                          })),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error al registrar: $e")),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("¿Ya tienes cuenta? ", style: TextStyle(color: Colors.grey[700])),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Quita esta pantalla y vuelve al login de forma limpia
                        },
                        child: const Text(
                          "Inicia Sesión",
                          style: TextStyle(
                            color: Colors.deepOrange,
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