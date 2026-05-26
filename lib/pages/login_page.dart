import 'package:flutter/material.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'custom_input.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant_menu, size: 80, color: Colors.deepOrange),
              SizedBox(height: 20),
              Text("Mi Sazón", style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
              SizedBox(height: 30),
              CustomInput(controller: emailController, label: "Correo electrónico"),
              SizedBox(height: 15),
              CustomInput(controller: passwordController, label: "Contraseña", obscure: true),
              SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Iniciar Sesión"),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => HomePage()),
                  );
                },
              ),
              TextButton(
                child: Text("¿No tienes cuenta? Regístrate"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
