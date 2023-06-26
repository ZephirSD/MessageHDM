const express = require('express')
const router = express.Router()

const { getEvents, getOneEvent, eventsCreate, deleteEvents } = require('../controllers/evenementsControllers');

const securite = require('../middleware/verifToken');

router.get('/', securite.checkJWT, getEvents);
router.get('/:eventID', securite.checkJWT,getOneEvent);
router.post('/', securite.checkJWT, eventsCreate);
router.delete('/:eventID', securite.checkJWT, deleteEvents);

module.exports = router;