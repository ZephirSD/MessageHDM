const { check, validationResult } = require("express-validator");
const { StatusCodes } = require("http-status-codes");


const validateSignUpRequest = [
check("pseudo").notEmpty().withMessage("Vous devez definir un Pseudo"),
check("email").isEmail().withMessage("Votre email n'est pas valide"),
check("password")
   .isLength({ min: 6 })
   .withMessage("Votre mot de passe doit avoir au minimum 6 caractères"),
];
const validateSignIpRequest = [
check("email").isEmail().withMessage("Votre email n'est pas valide"),
check("password")
    .isLength({ min: 6 })
    .withMessage("Votre mot de passe doit avoir au minimum 6 caractères"),
]
const isRequestValidated = (req, res, next) => {
  const errors = validationResult(req);
 
  if (errors.array().length > 0) {
      return res
              .status(StatusCodes.BAD_REQUEST)
              .json({ error: errors.array()[0].msg });
  }
  next();
};
module.exports = {
    validateSignUpRequest,
    isRequestValidated,
    validateSignIpRequest,
};