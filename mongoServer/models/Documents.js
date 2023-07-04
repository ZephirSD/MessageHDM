const mongoose = require("mongoose");
const documentSchema = new mongoose.Schema({
  nom_fichier: {
     type: String,
     unique: true,
  },
  extension: {
     type: String,
  },
  data_document: {
     type: Buffer,
  },
  idUser: {
    type: String,
  }
},{ timestamps: true });
module.exports = mongoose.model("Documents", documentSchema);