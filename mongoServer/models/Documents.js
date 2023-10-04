const mongoose = require("mongoose");
const documentSchema = new mongoose.Schema({
  nom_fichier: {
     type: String,
     require: true,
  },
  extension: {
     type: String,
     require: true,
  },
  data_document: {
     type: Buffer,
     require: true,
  },
  idUser: {
    type: String,
    require: true,
  }
},{ timestamps: true });
module.exports = mongoose.model("Documents", documentSchema);