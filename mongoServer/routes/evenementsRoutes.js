const express = require('express')
const router = express.Router()

const { getEvents, getOneEvent, eventsCreate, modifAccepInvite, eventInvitePrive, refusAccepInvite } = require('../controllers/evenementsControllers');

const securite = require('../middleware/verifToken');

router.get('/', securite.checkJWT, getEvents);
router.post('/event-invite', securite.checkJWT, eventInvitePrive);
router.get('/:eventID', securite.checkJWT,getOneEvent);
router.post('/', securite.checkJWT, eventsCreate);
router.put('/invite/:eventID', securite.checkJWT, modifAccepInvite);
router.put('/invite-refus/:eventID', securite.checkJWT, refusAccepInvite);
// router.delete('/:eventID', securite.checkJWT, deleteEvents);

module.exports = router;