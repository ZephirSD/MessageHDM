const Notifications = require('../models/Notifications');

const notifCreate = ((req, res) => {
    Notifications.create(
        {
            evenements: req.body.evenements,
            type_notif: req.body.type_notif,
            message_notif: req.body.message_notif,
            destin_notif: req.body.destin_notif
        }
    )
    .then(result => res.status(200).json({ result }))
    .catch(error => res.status(500).json({msg: error}))
})

const getNotifByPseudo = ((req, res) => {
    Notifications.find({ destin_notif: req.params.pseudo })
    .then(result => res.status(200).json({ result }))
    .catch(error => res.status(500).json({msg: error}))
})

const supprimeNotifi = ((req, res) => {
    Notifications.findByIdAndDelete(req.params.notifID)
    .then(result => {
        if(result){
            res.status(200).json({msg: 'Vous avez supprimé la notification.'});
        }
    })
    .catch(error => res.status(500).json({msg: error}))
})

module.exports = { notifCreate, getNotifByPseudo, supprimeNotifi };