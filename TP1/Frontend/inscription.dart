import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InscriptionPage extends StatefulWidget {
  @override
  _InscriptionPageState createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> createUser() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/users'), // Partie 1: URL de l'API pour créer un utilisateur
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8', // Partie 2: En-tête pour spécifier le type de contenu JSON
      },
      body: jsonEncode(<String, String>{
        'username': _usernameController.text, // Partie 3: Nom d'utilisateur
        'password': _passwordController.text, // Partie 4: Mot de passe
      }),
    );

    if (response.statusCode == 201) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Succès'),
            content: Text('Utilisateur créé avec succès.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text('Une erreur s\'est produite lors de la création de l\'utilisateur.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'), // Partie 5: Barre de titre
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                  prefixIcon: Icon(Icons.person), // Partie 6: Icône utilisateur
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: Icon(Icons.lock), // Partie 7: Icône cadenas
                ),
                obscureText: true, // Partie 8: Masquer le texte du mot de passe
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: createUser, // Partie 9: Appel de la fonction pour créer un utilisateur
                child: Text('S\'inscrire'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
