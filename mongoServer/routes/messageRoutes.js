const express = require('express')
const router = express.Router()

const { getMessagesEvents, postMessagesEvents } = require('../controllers/messagesControllers');

router.get('/:eventID', getMessagesEvents);
router.post('/:eventID', postMessagesEvents);

module.exports = router;