const express = require('express');
const mysql = require('mysql');
const app = express();
const port = 3000;

// Middleware pour analyser les requêtes JSON
app.use(express.json());

// Création de la connexion à la base de données
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'login',
});

// Connexion à la base de données
connection.connect((err) => {
  if (err) {
    console.error('Erreur de connexion à la base de données:', err.message);
    // Gérer l'erreur de connexion ici
  } else {
    console.log('Connecté à la base de données MySQL');
  }
});

// Route pour la connexion
app.post('/users', (req, res) => {
  const { username, password } = req.body;

  connection.query('INSERT INTO users (username, password) VALUES (?, ?)', [username, password], (err, result) => {
    if (err) {
      console.error('Erreur lors de l\'exécution de la requête:', err.message);
      res.status(500).json({ message: 'Erreur lors de la création de l\'utilisateur' });
    } else {
      res.status(201).json({ message: 'Utilisateur créé avec succès' });
    }
  });
});


// Route pour obtenir tous les utilisateurs
app.get('/users', (req, res) => {
  connection.query('SELECT * FROM users', (err, rows) => {
    if (err) {
      console.error('Erreur lors de l\'exécution de la requête:', err.message);
      res.status(500).json({ message: 'Erreur lors de la récupération des utilisateurs' });
    } else {
      res.json(rows);
    }
  });
});

//route pour obtenir un utilisateur spécifique
app.get('/users/:id', (req, res) => {
  const userId = req.params.id; // Récupère l'ID de l'utilisateur depuis les paramètres d'URL
  
  connection.query('SELECT * FROM users WHERE id = ?', [userId], (err, rows) => {
    if (err) {
      console.error('Erreur lors de l\'exécution de la requête:', err.message);
      res.status(500).json({ message: 'Erreur lors de la récupération de l\'utilisateur' });
    } else {
      if (rows.length > 0) {
        res.json(rows[0]); // Renvoie le premier utilisateur trouvé
      } else {
        res.status(404).json({ message: 'Utilisateur non trouvé' });
      }
    }
  });
});

// Route pour modifier un utilisateur
app.put('/users/:id', (req, res) => {
  const { id } = req.params;
  const { username, password } = req.body;

  connection.query('UPDATE users SET username = ?, password = ? WHERE id = ?', [username, password, id], (err, result) => {
    if (err) {
      console.error('Erreur lors de l\'exécution de la requête:', err.message);
      res.status(500).json({ message: 'Erreur lors de la mise à jour de l\'utilisateur' });
    } else if (result.affectedRows > 0) {
      res.json({ message: 'Utilisateur mis à jour avec succès' });
    } else {
      res.status(404).json({ message: 'Utilisateur non trouvé' });
    }
  });
});


//Cela permet d'utiliser cet objet app dans d'autres fichiers de votre application
module.exports = app ;
