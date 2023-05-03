const mongoose = require("mongoose");
const bcrypt = require("bcrypt");
const userSchema = new mongoose.Schema({
  pseudo: {
     type: String,
     require: true,
     trim: true,
     min: 3,
     max: 20,
  },
  email: {
     type: String,
     require: true,
     trim: true,
     unique: true,
     lowercase: true,
  },
  passwordUser: {
     type: String,
     require: true,
  },
  telephone: {
     type: String,
  },
},{ timestamps: true });
//For get fullName from when we get data from database
// userSchema.virtual("fullName").get(function () {
//   return `${this.firstName} ${this.lastName}`;
// });
userSchema.method({
  async authenticate(password) {
     return bcrypt.compare(password, this.passwordUser);
  },
});
module.exports = mongoose.model("utilisateurs", userSchema);