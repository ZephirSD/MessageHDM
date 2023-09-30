const jwt = require('jsonwebtoken');
const JWT_SECRET_KEY = process.env.JWT_SECRET_KEY;

// Fonction externe pour vérifier le token 
exports.checkJWT = async (req, res, next) => {
    // Variable token à partir de headers de la requête
    let token = req.headers['x-access-token'] || req.headers['authorization'];
    // Vérifier si le token commence par `Bearer` 
    if (!!token && token.startsWith('Bearer ')) {
        token = token.slice(7, token.length);
    }
    // Token existant 
    if (token) {
        jwt.verify(token, JWT_SECRET_KEY, (err, decoded) => {
            // Token non valide
            if (err) {
                return res.status(401).json('Le token est non valide');
            // Token valide
            } else {
                req.decoded = decoded;
                // Variable pour définir un délai d'expiration de token
                const expiresIn = 24 * 60 * 60;
                // Création de la variable de token avec la requête
                const newToken  = jwt.sign({
                    user : decoded.user
                },
                JWT_SECRET_KEY,
                {
                    expiresIn: expiresIn
                });
                // Réponse d'envoi d'autorisation
                res.header('Authorization', 'Bearer ' + newToken);
                next();
            }
        });
    // Token non existant
    } else {
        return res.status(401).json('Le token est recommandé');
    }
}