const { StatusCodes } = require("http-status-codes");
const User = require("../models/Users");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const shortid = require("shortid");
const signUp = async (req, res) => {
  const { pseudo, email, passwordUser, telephone } = req.body;
  if (!pseudo || !email || !passwordUser) {
     return res.status(StatusCodes.BAD_REQUEST).json({
        message: "Information impossible",
     });
  }

  const passwordContr = await bcrypt.hash(passwordUser, 10);
  
  const userData = {
     pseudo,
     email,
     passwordUser: passwordContr,
     telephone,
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
        .json({ message: "L'utilisateur a été crée avec succès" });
     });
    }
};
const signIn = async (req, res) => {
  try {
     if (!req.body.email || !req.body.passwordUser) {
        res.status(StatusCodes.BAD_REQUEST).json({
           message: "Entrez un email et une mot de passe",
        });
     }
 
     const user = await User.findOne({ email: req.body.email });
    
     if (user) {
      const passwordHash = user.passwordUser;
      bcrypt.compare(req.body.passwordUser, passwordHash, function(err, passwordMatch){
         if(passwordMatch) {
            const token = jwt.sign(
               { _id: user._id, pseudo: user.pseudo },
               process.env.JWT_SECRET_KEY,{ expiresIn: "30d"}
            );
            const { _id, pseudo, email } = user;
            res.status(StatusCodes.OK).json({
                  token,
                  user: { _id, pseudo, email },
            });
         }
         else{
            res.status(StatusCodes.UNAUTHORIZED).json({
               message: "Mauvais informations!",
            });   
         }
      })
} else {
  res.status(StatusCodes.BAD_REQUEST).json({
      message: "L'utilisateur n'existe pas",
  });
}
} catch (error) {
   res.status(StatusCodes.BAD_REQUEST).json({ error });
  }
};
module.exports = { signUp, signIn };