import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_red_social/List.dart';
import 'package:flutter_red_social/create.dart';
import 'package:flutter_red_social/detailScreen.dart';
import 'package:flutter_red_social/home.dart';
import 'package:flutter_red_social/login.dart';
import 'package:flutter_red_social/splashScreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Redes Sociales',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => SplashScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => LoginScreen());
          case '/home':
            return MaterialPageRoute(builder: (_) => HomeScreen());
          case '/list':
            return MaterialPageRoute(builder: (_) => PostListScreen());
          case '/detail':
            final post = settings.arguments as DocumentSnapshot;
            return MaterialPageRoute(builder: (_) => PostDetailScreen(post: post));
          case '/create':
            return MaterialPageRoute(builder: (_) => PostFormScreen());
          case '/edit':
            final post = settings.arguments as DocumentSnapshot;
            return MaterialPageRoute(builder: (_) => PostFormScreen(post: post));
          default:
            // Si no coincide con ninguna ruta, redirige al login
            return MaterialPageRoute(builder: (_) => LoginScreen());
        }
      },
    );
  }
}
