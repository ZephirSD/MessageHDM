const mongoose = require("mongoose");
const eventSchema = new mongoose.Schema({
  nom_event: {
     type: String,
     require: true,
  },
  date_debut: {
     type: Date,
  },
  date_fin: {
     type: Date,
  },
  mode_event: {
     type: String,
  },
  create_event: {
    type: String,
  },
  invite_prive: [{
   pseudo: {
      type: String,
   },
   accept: {
      type: Boolean,
   }
  }]
},{ timestamps: true });
module.exports = mongoose.model("Evenements", eventSchema);