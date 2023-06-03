const Evenements = require('../models/Evenements');

const getEvents = ((req, res) => {
    Evenements.find({})
        .then(result => res.status(200).json({ result }))
        .catch(error => res.status(500).json({msg: error}))
})

const getOneEvent = ((req, res) => {
    Evenements.find({_id: req.params.eventID})
        .then(result => res.status(200).json({ result }))
        .catch(error => res.status(500).json({msg: error}))
})

const eventsCreate = ((req, res) => {
    Evenements.create(req.body)
        .then(result => res.status(200).json({ result }))
        .catch(error => res.status(500).json({msg: error}))
})

module.exports = { getEvents, getOneEvent, eventsCreate };