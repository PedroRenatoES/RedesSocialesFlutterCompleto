import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Pantalla de inicio de sesión con opciones de login y registro
class LoginScreen extends StatelessWidget {
  // Controladores para capturar los datos de email y contraseña
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Instancias de FirebaseAuth y FirebaseFirestore para la autenticación y el almacenamiento en Firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de texto para ingresar el email
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            // Campo de texto para ingresar la contraseña
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            // Botón para iniciar sesión
            ElevatedButton(
              onPressed: () => _loginUser(context), 
              child: Text("Ingresar"),
            ),
            // Botón de texto para registrarse, redirige a la función de registro
            TextButton(
              onPressed: () => _registerUser(context), 
              child: Text("Registrarse"),
            ),
          ],
        ),
      ),
    );
  }

  // Función para iniciar sesión en Firebase
  Future<void> _loginUser(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Navegar a la pantalla de inicio ('/home') si el inicio de sesión es exitoso
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Muestra un diálogo de error si el inicio de sesión falla
      _showErrorDialog(context, "Error al iniciar sesión: ${e.toString()}");
    }
  }

  // Función para registrar al usuario en Firebase y guardar datos adicionales en Firestore
  Future<void> _registerUser(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Guarda información adicional del usuario en Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': emailController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      // Navegar a la pantalla de inicio ('/home') después de registrarse exitosamente
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Muestra un diálogo de error si el registro falla
      _showErrorDialog(context, "Error al registrarse: ${e.toString()}");
    }
  }

  // Función para mostrar un diálogo de error en caso de fallo
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cerrar"),
          ),
        ],
      ),
    );
  }
}
