const express = require("express");
require("dotenv").config();
const connectDB = require("./db/connect");
const app = express();
const fs = require('fs');
const path = require('path');
const https = require('https');
var cors = require("cors");


const authRouter = require("./routes/auth");
const messagesRouter = require("./routes/messageRoutes");
const eventsRouter = require("./routes/evenementsRoutes");
const documentRouter = require("./routes/documentsRoutes");
const notificationRouter = require("./routes/notificationsRoutes");

app.use(cors());
app.use(express.json());
app.use("/api", authRouter);
app.use("/api/messages", messagesRouter);
app.use("/api/evenements", eventsRouter);
app.use("/api/documents", documentRouter);
app.use("/api/notifications", notificationRouter);

// Lecture du fichier server.key pour obtenir la clé du certificat
const key = fs.readFileSync(path.join(__dirname, 'certificate', 'server.key'));
// Lecture du fichier server.cert pour obtenir le certificat SSL
const cert = fs.readFileSync(path.join(__dirname, 'certificate', 'server.cert'));
// Création des options avec la clé et le certificat
const options = { key, cert };
// Le port du serveur NodeJS
const port = 8000;
// Fonction pour démarrer le serveur NodeJS
const start = async () => {
  try {
    // Connexion vers la base de données MessageHDMBase MongoDB 
    await connectDB(process.env.MONGO_CONNECTION).then(() => {
      // Création du serveur avec le protocole HTTPS
      https.createServer(options, app).listen(port, () => {
        console.log(`Vous êtes sur le port ${port}`);
      });
    }).catch((err) => {
      console.log("error =>", err);
    });
  }
  catch (err) {
    console.log("error =>", err);
  }
};
start();