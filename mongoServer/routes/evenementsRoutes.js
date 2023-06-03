const express = require('express')
const router = express.Router()

const { getEvents, getOneEvent, eventsCreate } = require('../controllers/evenementsControllers');

router.get('/', getEvents);
router.get('/:eventID', getOneEvent);
router.post('/', eventsCreate);

module.exports = router;