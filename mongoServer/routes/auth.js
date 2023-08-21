const express = require("express");
const router = express.Router();
const { signUp, signIn, modifUser, getUser, getAllUsers, modifPassword } = require("../controllers/userControllers");
const {  
  isRequestValidated,
  validateSignUpRequest,
  validateSignIpRequest,
} = require("../validators/valide");
const securite = require('../middleware/verifToken');


router.route("/connec").post(validateSignIpRequest, isRequestValidated, signIn);
router.route("/inscrip").post(validateSignUpRequest, isRequestValidated, signUp);
router.get("/getAllUser", securite.checkJWT, getAllUsers);
router.get("/getUser/:userID", securite.checkJWT, getUser);
router.put("/modifUser/:userID", securite.checkJWT, modifUser);
router.put("/modifPassword/:userID", securite.checkJWT, modifPassword);

module.exports = router;