const express = require('express')
const router = express.Router()

const { notifCreate, getNotifByPseudo, supprimeNotifi } = require('../controllers/notificationsControllers');
const securite = require('../middleware/verifToken');

router.post('/', securite.checkJWT, notifCreate);
router.get('/:pseudo',securite.checkJWT, getNotifByPseudo); 
router.delete('/supprNotif/:notifID',securite.checkJWT, supprimeNotifi); 

module.exports = router;
