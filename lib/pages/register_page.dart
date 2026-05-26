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
      appBar: AppBar(title: Text("Crear Cuenta")),
      body: Padding(
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("Registrarse"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
