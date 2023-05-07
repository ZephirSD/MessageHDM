const express = require("express");
const router = express.Router();
const { signUp, signIn } = require("../controllers/userControllers");
const {  
  isRequestValidated,
  validateSignUpRequest,
  validateSignIpRequest,
} = require("../validators/valide");


router.route("/connec").post(validateSignIpRequest, isRequestValidated, signIn);


router.route("/inscrip").post(validateSignUpRequest, isRequestValidated, signUp);


module.exports = router;