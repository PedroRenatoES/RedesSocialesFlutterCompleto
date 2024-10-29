import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Inicia un temporizador para redirigir después de 3 segundos
    Future.delayed(Duration(seconds: 3), () async {
      try {
        // Verifica si el usuario está autenticado
        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.pushReplacementNamed(context, '/home'); // Usuario autenticado
        } else {
          Navigator.pushReplacementNamed(context, '/login'); // Usuario no autenticado
        }
      } catch (e) {
        print("Error al verificar la autenticación: $e");
        // Manejar el error, podrías redirigir a una pantalla de error o de login
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/logo.jpeg'), // Asegúrate de que este archivo exista
            SizedBox(height: 20),
            Text(
              "Gestor de Redes Sociales",
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
