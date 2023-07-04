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
app.use(cors());
app.use(express.json());
app.use("/api", authRouter);
app.use("/api/messages", messagesRouter);
app.use("/api/evenements", eventsRouter);
app.use("/api/documents", documentRouter);
const key = fs.readFileSync(path.join(__dirname, 'certificate', 'server.key'));
const cert = fs.readFileSync(path.join(__dirname, 'certificate', 'server.cert'));
const options = { key, cert };

const port = 8000;
const start = async () => {
  try {
    await connectDB(process.env.MONGO_CONNECTION).then(() => {
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