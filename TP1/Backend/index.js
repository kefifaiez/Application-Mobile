const http = require('http');
const app = require('./app');

// Création du serveur HTTP en utilisant l'application Express
const server = http.createServer(app);

// Définition du port sur lequel le serveur écoutera les requêtes
const port = process.env.PORT || 3000;

// Démarrage du serveur
server.listen(port, () => {
  console.log(`Serveur en cours d'exécution sur le port ${port}`);
});

// Route pour la connexion d'un utilisateur
app.post('/users/login', (req, res) => {
  const { username, password } = req.body;

  connection.query('SELECT * FROM users WHERE username = ? AND password = ?', [username, password], (err, rows) => {
    if (err) {
      console.error('Erreur lors de l\'exécution de la requête:', err.message);
      res.status(500).json({ message: 'Erreur lors de la vérification des informations de connexion' });
    } else {
      if (rows.length > 0) {
        res.json({ message: 'Utilisateur connecté' });
      } else {
        res.status(401).json({ message: 'Nom d\'utilisateur ou mot de passe incorrect' });
      }
    }
  });
});