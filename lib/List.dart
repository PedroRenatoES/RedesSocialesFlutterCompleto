import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lista de Publicaciones",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 10,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.indigoAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(color: Colors.white));
            }
            final posts = snapshot.data?.docs;
            return ListView.builder(
              itemCount: posts?.length,
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                String socialMediaLogo = _getSocialMediaLogo(posts![index]['redSocial']); // Suponiendo que tienes el campo 'socialMedia' en tu documento

                return Card(
                  color: Colors.deepPurple.shade400,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Row(
                      children: [
                        Image.asset(
                          socialMediaLogo,
                          height: 30, // Ajusta el tamaño del logo
                          width: 30,
                        ),
                        SizedBox(width: 8), // Espacio entre el logo y el texto
                        Expanded(
                          child: Text(
                            posts[index]['title'] ?? 'Sin título',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      posts[index]['scheduledDate'] ?? 'Sin fecha',
                      style: TextStyle(color: Colors.white70),
                    ),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: posts[index],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _getSocialMediaLogo(String socialMedia) {
    // Mapea el nombre de la red social a la ruta de la imagen correspondiente
    switch (socialMedia) {
      case 'Facebook':
        return 'images/facebook_logo.png';
      case 'WhatsApp':
        return 'images/whatsapp_logo.png';
      case 'Instagram':
        return 'images/instagram_logo.png';
      case 'TikTok':
        return 'images/tiktok_logo.jpg';
      default:
        return 'images/default_logo.png'; // Logo por defecto si no se encuentra
    }
  }
}
