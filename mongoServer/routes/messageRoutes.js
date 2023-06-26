const express = require('express')
const router = express.Router()

const { getMessagesEvents, postMessagesEvents } = require('../controllers/messagesControllers');
const securite = require('../middleware/verifToken');

router.get('/:eventID', securite.checkJWT, getMessagesEvents);
router.post('/', securite.checkJWT, postMessagesEvents);

module.exports = router;