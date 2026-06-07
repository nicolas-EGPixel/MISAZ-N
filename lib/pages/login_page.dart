import 'package:flutter/material.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'custom_input.dart';
import '/base_de_datos/db_helper.dart';

class LoginPage extends StatelessWidget {
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
                  Text("Iniciar Sesión",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 5),
                  Text("Bienvenido a Mi Sazón 🍲", style: TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
            ),

            // Formulario
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
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
                    child: Text("Entrar",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    onPressed: () async {
                      String email = emailController.text.trim();
                      
                      // Expresión regular para validar formato de correo electrónico
                      RegExp emailRegExp = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                      );

                      if (email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Por favor, ingresa tu correo")),
                        );
                        return; // Detiene la ejecución
                      }

                      if (!emailRegExp.hasMatch(email)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("El formato del correo no es válido (ejemplo@dominio.com)")),
                        );
                        return; // Detiene la ejecución si no tiene @ o formato correcto
                      }

                      // Si pasa las validaciones, continúa con la lógica que hizo tu compañero:
                      try {
                        var usuario = await DBHelper.login(
                          email,
                          passwordController.text,
                        );

                        if (usuario != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => HomePage(usuario: usuario)),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Correo o contraseña incorrectos")),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error en login: $e")),
                        );
                      }
                    },
                  ),

                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("¿No tienes cuenta? ", style: TextStyle(color: Colors.grey[700])),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage()));
                        },
                        child: Text("Regístrate",
                            style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
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
