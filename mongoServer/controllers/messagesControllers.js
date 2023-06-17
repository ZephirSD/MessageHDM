const Messages = require('../models/Messages');

const getMessagesEvents = ((req, res) => {
    Messages.find({evenement: req.params.eventID})
        .then(result => res.status(200).json({ result }))
        .catch(error => res.status(500).json({msg: error}))
})

const postMessagesEvents = ((req, res) => {
    Messages.create(req.body)
        .then(result => res.status(200).json({ result }))
        .catch(error => res.status(500).json({msg: error}))
})

module.exports = { getMessagesEvents, postMessagesEvents };