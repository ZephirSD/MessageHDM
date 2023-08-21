const fs = require('fs');
const path = require('path');
const Messages = require('../models/Messages');
const Documents = require('../models/Documents');

const getMessagesEvents = ((req, res) => {
    Messages.find({evenement: req.params.eventID})
        .then(result => res.status(200).json({ result }))
        .catch(error => res.status(500).json({msg: error}))
})

const postMessagesEvents = ((req, res) => {
    if(req.body.lien_fichier != null){
        const fichierTemp = fs.readFileSync(path.resolve(req.body.lien_fichier));
        const base64fichierTemp = fichierTemp.toString('base64');
        Messages.create({
            auteur: req.body.auteur,
            evenement: req.body.evenement,
            document: Buffer(base64fichierTemp, 'base64'),
            date_envoi: req.body.date_envoi
        })
        Documents.create({
            nom_fichier: req.body.nom_fichier,
        extension: req.body.extension.toLowerCase(),
        data_document: Buffer(base64fichierTemp, 'base64'),
        idUser: req.body.idUser
        })  
        .then(result => res.status(200).json({ message: "Message envoyé" }))
            .catch(error => res.status(500).json({msg: error}))
    }
    else{
        Messages.create({
            auteur: req.body.auteur,
            evenement: req.body.evenement,
            texte: req.body.texte,
            date_envoi: req.body.date_envoi
        })
            .then(result => res.status(200).json({ result }))
            .catch(error => res.status(500).json({msg: error}))
    }
})

module.exports = { getMessagesEvents, postMessagesEvents };