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

