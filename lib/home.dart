import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gestor de Publicaciones",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 10,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white,),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.indigoAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildSocialMediaCard(
              context,
              'Facebook',
              'images/facebook_logo.png',
              Colors.blue[800]!,
            ),
            _buildSocialMediaCard(
              context,
              'WhatsApp',
              'images/whatsapp_logo.png',
              Colors.green[700]!,
            ),
            _buildSocialMediaCard(
              context,
              'Instagram',
              'images/instagram_logo.png',
              Colors.pink[400]!,
            ),
            _buildSocialMediaCard(
              context,
              'TikTok',
              'images/tiktok_logo.jpg',
              Colors.black87,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Listado"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Crear"),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/list');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/create');
          }
        },
      ),
    );
  }

  Widget _buildSocialMediaCard(
      BuildContext context, String name, String logoPath, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/create');
      },
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 8,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Image.asset(
                  logoPath,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 12),
              Text(
                name,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    // Realiza la lógica de logout aquí, como limpiar datos de usuario o tokens

    // Navega a la pantalla de login
    Navigator.pushReplacementNamed(context, '/login');
  }
}
