const mongoose = require("mongoose");
const eventSchema = new mongoose.Schema({
  nomEvent: {
     type: String,
     require: true,
  },
  dateDebut: {
     type: Date,
     require: true,
  },
  dateFin: {
     type: Date,
     require: true,
  },
  modeEvent: {
     type: Boolean,
     require: true,
  },
  createEvent: {
    type: String,
  }
},{ timestamps: true });
module.exports = mongoose.model("evemenements", eventSchema);