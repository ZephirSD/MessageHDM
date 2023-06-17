const mongoose = require("mongoose");
const messageSchema = new mongoose.Schema({
  auteur: {
    type: String,
  },
  evenement: {
    type: String,
  },
  status: {
    type: String,
  },
  texte: {
    type: String,
  },
  date_envoi: {
    type: Date,
  }
},{ timestamps: true });
module.exports = mongoose.model("Messages", messageSchema);