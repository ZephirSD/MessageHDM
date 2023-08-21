const mongoose = require("mongoose");
const messageSchema = new mongoose.Schema({
  auteur: {
    type: String,
  },
  evenement: {
    type: String,
  },
  texte: {
    type: String,
  },
  document: {
    type: Buffer,
  },
  date_envoi: {
    type: Date,
  }
},{ timestamps: true });
module.exports = mongoose.model("Messages", messageSchema);