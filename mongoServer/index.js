const express = require("express");
require("dotenv").config();
const connectDB = require("./db/connect");
const app = express();
var cors = require("cors");
const authRouter = require("./routes/auth");
const messagesRouter = require("./routes/messageRoutes");
const eventsRouter = require("./routes/evenementsRoutes");
app.use(cors());
app.use(express.json());
app.use("/api", authRouter);
app.use("/api/messages", messagesRouter);
app.use("/api/evenements", eventsRouter);
const port = 8000;
const start = async () => {
  try {
    await connectDB(process.env.MONGO_CONNECTION).then(() => {
      app.listen(port, () => {
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