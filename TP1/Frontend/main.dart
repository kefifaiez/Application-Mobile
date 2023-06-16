import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'inscription.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // Supprime le sigle "Debug"
      home: LoginPage(), // Partie 1: Page de connexion
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false; // Variable pour gérer la visibilité du mot de passe
  String _message = '';

  Future<void> authenticateUser() async {
    final response = await http.get(Uri.parse('http://localhost:3000/users')); // Partie 2: Requête GET pour obtenir la liste des utilisateurs
    if (response.statusCode == 200) {
      final List<dynamic> users = json.decode(response.body); // Partie 3: Décodage de la réponse JSON
      final String username = _usernameController.text;
      final String password = _passwordController.text;

      bool isAuthenticated = false;
      for (var user in users) {
        if (user['username'] == username && user['password'] == password) { // Partie 4: Comparaison des informations de connexion avec la base de données
          isAuthenticated = true;
          break;
        }
      }

      setState(() {
        if (isAuthenticated) {
          _message = 'Vous êtes connecté avec succès.'; // Partie 5: Affichage d'un message de succès
        } else {
          _message = 'Problème d\'authentification. Veuillez réessayer.'; // Partie 6: Affichage d'un message d'erreur
        }
      });
    } else {
      print('Erreur lors de la récupération des utilisateurs.'); // Partie 7: Affichage d'un message d'erreur en cas d'échec de la requête GET
    }
  }

  void navigateToUsersPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UsersPage()), // Partie 8: Navigation vers la page des utilisateurs
    );
  }

  void navigateToInscriptionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InscriptionPage()), // Partie 9: Navigation vers la page d'inscription
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'), // Partie 10: Barre de titre
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200.0,
                child: Icon(Icons.android, size: 150.0), // Partie 11: Icône Android plus grande
              ),
              SizedBox(height: 2.0),
              Text(
                'Bienvenue de nouveau',
                style: TextStyle(fontSize: 30.0), // Partie 12: Police plus grande
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                  prefixIcon: Icon(Icons.person), // Partie 13: Icône utilisateur
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: Icon(Icons.lock), // Partie 14: Icône cadenas
                  suffixIcon: IconButton(
                    icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off), // Partie 15: Icône pour afficher/masquer le mot de passe
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible; // Inversion de l'état de visibilité du mot de passe
                      });
                    },
                  ),
                ),
                obscureText: !_passwordVisible, // Affiche le texte du mot de passe uniquement si _passwordVisible est true
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: authenticateUser, // Partie 16: Appel de la fonction d'authentification lors de l'appui sur le bouton de connexion
                child: Text('Login', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 16.0),
              Text(
                _message, // Partie 17: Affichage du message de succès ou d'erreur
                style: TextStyle(
                  color: _message.startsWith('Problème') ? Colors.red : Colors.blue,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Veuillez s\'inscrire si vous ne possède pas de login',
                style: TextStyle(fontSize: 16.0), // Partie 12: Police plus grande
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: navigateToInscriptionPage, // Partie 18: Navigation vers la page d'inscription
                child: Text('S\'inscrire'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToUsersPage, // Partie 19: Naviguer vers la page des utilisateurs lors de l'appui sur le bouton "GET"
        child: Text('GET'), // Partie 20: Texte "GET" au lieu de l'icône
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Partie 21: Positionnement du bouton "GET" en bas à droite
    );
  }
}

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<dynamic> users = [];

  Future<void> getUsers() async {
    final response = await http.get(Uri.parse('http://localhost:3000/users')); // Partie 22: Envoie d'une requête GET pour obtenir la liste des utilisateurs

    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body); // Partie 23: Décodage de la réponse JSON contenant la liste des utilisateurs
      });
    } else {
      print('Erreur lors de la récupération des utilisateurs.'); // Partie 24: Affichage d'un message d'erreur en cas d'échec de la requête GET
    }
  }

  @override
  void initState() {
    super.initState();
    getUsers(); // Partie 25: Appel de la fonction pour récupérer la liste des utilisateurs lors de l'initialisation de la page
  }
//interface graphique utilisateur
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Utilisateurs'), // Partie 26: Barre de titre
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          final user = users[index];
          return ListTile(
            title: Text(user['username']), // Partie 27: Affichage du nom d'utilisateur
            subtitle: Text(user['password']), // Partie 28: Affichage du mot de passe
          );
        },
      ),
    );
  }
}
