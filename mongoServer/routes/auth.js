const express = require("express");
const router = express.Router();
// Export des fonctions de controller
const { signUp, signIn, modifUser, getUser, getAllUsers, modifPassword } = require("../controllers/userControllers");
// Export de vérification des champs du formulaire
const {  
  isRequestValidated,
  validateSignUpRequest,
  validateSignIpRequest,
} = require("../validators/valide");
// Export de la fonction pour la vérification du token
const securite = require('../middleware/verifToken');
// Routes pour `utilisateurs`
router.route("/connec").post(validateSignIpRequest, isRequestValidated, signIn);
router.route("/inscrip").post(validateSignUpRequest, isRequestValidated, signUp);
router.get("/getAllUser", securite.checkJWT, getAllUsers);
router.get("/getUser/:userID", securite.checkJWT, getUser);
router.put("/modifUser/:userID", securite.checkJWT, modifUser);
router.put("/modifPassword/:userID", securite.checkJWT, modifPassword);

module.exports = router;