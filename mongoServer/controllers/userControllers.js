const { StatusCodes } = require("http-status-codes");
const User = require("../models/Users");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");

// Controller pour effectuer un création de compte
const signUp = async (req, res) => {
   // Initialisation des différents variables de la requête
  const { pseudo, email, passwordUser, telephone } = req.body;
   // Affiche un erreur lors les inforamtions ne sont pas definis
  if (!pseudo && !email && !passwordUser) {
     return res.status(StatusCodes.BAD_REQUEST).json({
        message: "Information impossible",
     });
  }

   // Hashage du mot de passe en bcrypt
  const passwordContr = await bcrypt.hash(passwordUser, 10);
  
   // Variable ayant le corps de la requête
  const userData = {
     pseudo,
     email,
     passwordUser: passwordContr,
     telephone,
  };

  const user = await User.findOne({ email });
   // Vérifie si l'email existe dans la base de données pour créer l'utilisateur
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

// Controller pour effectuer un connexion de compte
const signIn = async (req, res) => {
  try {
   // Lorsque l'email et les mot de passe ne pas définis
     if (!req.body.email || !req.body.passwordUser) {
        res.status(StatusCodes.BAD_REQUEST).json({
           message: "Entrez un email et une mot de passe",
        });
     }
 
     const user = await User.findOne({ email: req.body.email });
   //  Lorsque l'utilisateur existe
     if (user) {
      const passwordHash = user.passwordUser;
      bcrypt.compare(req.body.passwordUser, passwordHash, function(err, passwordMatch){
         // Lorsque le mot de passe est valide
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
         // Lorsque le mot de passe n'est pas valide
         else{
            res.status(StatusCodes.UNAUTHORIZED).json({
               message: "Mauvais informations!",
            });   
         }
      })
      // Lorsque l'utilisateur n'existe pas
} else {
  res.status(StatusCodes.BAD_REQUEST).json({
      message: "L'utilisateur n'existe pas",
  });
}
} catch (error) {
   res.status(StatusCodes.BAD_REQUEST).json({ error });
  }
};

// Controller pour modifier les informations de l'utilisateur
const modifUser = ((req, res) => {
   try{
      User.findByIdAndUpdate(req.params.userID, req.body)
      .then(res.status(StatusCodes.OK).json({ message: "Votre profil a bien été modifié" }))
      .catch(error => res.status(StatusCodes.BAD_REQUEST).json({msg: error}))
   }
   catch (error) {
      console.log(error);
   }
})

// Controller pour modifier le mot de passe de l'utilisateur
const modifPassword = async (req, res) => {
   const passwordHash = await bcrypt.hash(req.body.passwordUser, 10);
   try{
      User.findByIdAndUpdate(req.params.userID, {
         passwordUser: passwordHash,
      })
      .then(res.status(StatusCodes.OK).json({ message: "Votre mot de passe a bien été modifié" }))
      .catch(error => res.status(StatusCodes.BAD_REQUEST).json({msg: error}))
   }
   catch (error) {
      console.log(error);
   }
}

const getAllUsers = async (req, res) => {
   try{
      User.aggregate([{
         $project: {
            id: '$_id',
            display: '$pseudo',
         }
      }])
      .then(result => res.status(StatusCodes.OK).json({result}))
      .catch(error => res.status(StatusCodes.BAD_REQUEST).json({msg: error}))
   }
   catch (error){
      console.log(error);
   }
}

// Fonction pour recupérer les informations de l'utilisateur selectionné
const getUser = ((req, res) => {
   try{
      User.findById(req.params.userID)
      .then(result => res.status(StatusCodes.OK).json({ result: {email: result.email, pseudo: result.pseudo, telephone: result.telephone} }))
      .catch(error => res.status(StatusCodes.BAD_REQUEST).json({msg: error}))
   }
   catch (error) {
      console.log(error);
   }
})

module.exports = { signUp, signIn, modifUser, getUser, getAllUsers, modifPassword };