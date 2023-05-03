const { StatusCodes } = require("http-status-codes");
const User = require("../models/Users");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const shortid = require("shortid");
const signUp = async (req, res) => {
  const { pseudo, email, password } = req.body;
  if (!pseudo || !email || !password) {
     return res.status(StatusCodes.BAD_REQUEST).json({
        message: "Information impossible",
     });
  }

  const passwordUser = await bcrypt.hash(password, 10);
 
  const userData = {
     pseudo,
     email,
     passwordUser,
  };

  const user = await User.findOne({ email });
  if (user) {
     return res.status(StatusCodes.BAD_REQUEST).json({
        message: "L'utilisateur existe déjà",
     });
  } else {
     User.create(userData).then((data, err) => {
     if (err) res.status(StatusCodes.BAD_REQUEST).json({ err });
     else
       res
        .status(StatusCodes.CREATED)
        .json({ message: "L'utilisateur à été crée avec succès" });
     });
    }
};
const signIn = async (req, res) => {
  try {
     if (!req.body.email || !req.body.passwordUser) {
        res.status(StatusCodes.BAD_REQUEST).json({
           message: "Please enter email and password",
        });
     }
 
     const user = await User.findOne({ email: req.body.email });
    
     if (user) {
     if (user.authenticate(req.body.passwordUser)) {
           const token = jwt.sign(
              { _id: user._id, pseudo: user.pseudo },
              process.env.JWT_SECRET,{ expiresIn: "30d"});
  const { _id, pseudo, email } = user;
  res.status(StatusCodes.OK).json({
       token,
       user: { _id, pseudo, email },
  });
 } else {
  res.status(StatusCodes.UNAUTHORIZED).json({
     message: "Mauvais informations!",
  });
 }
} else {
  res.status(StatusCodes.BAD_REQUEST).json({
      message: "L'utilisation n'existe pas",
  });
}
} catch (error) {
   res.status(StatusCodes.BAD_REQUEST).json({ error });
  }
};
module.exports = { signUp, signIn};