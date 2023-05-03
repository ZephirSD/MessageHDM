const express = require("express");
require("dotenv").config();
const connectDB = require("./db/connect");
const app = express();
var cors = require("cors");
const authRouter = require("./routes/auth");
app.use(cors());
app.use(express.json());
app.use("/api", authRouter);
//Port and Connect to DB
const port = 8000;
const start = async () => {
  try {
    connectDB(process.env.MONGO_CONNECTION).then(() => {
      app.listen(port, () => {
           console.log(`Server is running on port ${port}`);
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