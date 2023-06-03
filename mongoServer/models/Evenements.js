const mongoose = require("mongoose");
const eventSchema = new mongoose.Schema({
  nom_event: {
     type: String,
     require: true,
  },
  date_debut: {
     type: Date,
     require: true,
  },
  date_fin: {
     type: Date,
     require: true,
  },
  mode_event: {
     type: Boolean,
     require: true,
  },
  create_event: {
    type: String,
  }
},{ timestamps: true });
module.exports = mongoose.model("evemenements", eventSchema);