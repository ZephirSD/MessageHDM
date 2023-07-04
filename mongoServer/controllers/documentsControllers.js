const Documents = require('../models/Documents');
const fs = require('fs');
const path = require('path');

const getDocumentsRecents = ((req, res) => {
    Documents.find({idUser: req.params.userID}).sort({createdAt: -1})
        .then(result => res.status(200).json({ result }))
        .catch(error => res.status(500).json({msg: error}))
})

const getListesDocuments = ((req, res) => {
    Documents.find({idUser: req.params.userID}).sort({nom_fichier: 1})
        .then(result => res.status(200).json({ result }))
        .catch(error => res.status(500).json({msg: error}))
})

const getDocumentById = ((req, res) => {
    Documents.findById({_id: req.params.docID})
        .then(result => res.status(200).json({ result }))
        .catch(error => res.status(500).json({msg: error}))
})

const postDocuments = ((req, res) => {
    const fichierTemp = fs.readFileSync(path.resolve(req.body.lien_fichier));
    const base64fichierTemp = fichierTemp.toString('base64');
    Documents.create({
        nom_fichier: req.body.nom_fichier,
        extension: req.body.extension,
        data_document: Buffer(base64fichierTemp, 'base64'),
        idUser: req.body.idUser
    })
    .then(result => res.status(200).json({ result }))
    .catch(error => res.status(500).json({msg: error}))
})

const deleteDocuments = ((req, res) => {
    Documents.findByIdAndDelete({_id: req.params.idDoc})
    .then(result => res.status(200).json({ result }))
    .catch(error => res.status(500).json({msg: error}))
})

module.exports = { getDocumentsRecents, getListesDocuments, getDocumentById, postDocuments, deleteDocuments };