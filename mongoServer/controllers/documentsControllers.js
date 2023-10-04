const Documents = require('../models/Documents');
const { StatusCodes } = require("http-status-codes");
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

const getListesDocumentsPDF = ((req, res) => {
    Documents.find({idUser: req.params.userID}).sort({nom_fichier: 1}).where({extension: 'pdf'})
        .then(result => res.status(200).json({ result }))
        .catch(error => res.status(500).json({msg: error}))
})

const getListesDocumentsImages = ((req, res) => {
    Documents.find({idUser: req.params.userID}).sort({nom_fichier: 1}).where('extension').in(['heic', 'jpg', 'png', 'gif', 'jpeg'])
        .then(result => res.status(200).json({ result }))
        .catch(error => res.status(500).json({msg: error}))
})

const getListesDocumentsWord = ((req, res) => {
    Documents.find({idUser: req.params.userID}).sort({nom_fichier: 1}).where('extension').in(['docx', 'doc', 'odt', 'pages'])
        .then(result => res.status(200).json({ result }))
        .catch(error => res.status(500).json({msg: error}))
})

const getListesDocumentsExcel = ((req, res) => {
    Documents.find({idUser: req.params.userID}).sort({nom_fichier: 1}).where('extension').in(['csv', 'xlsx', 'xls', 'ods'])
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
    Documents.create({
        nom_fichier: req.body.nom_fichier,
        extension: req.body.extension,
        data_document: Buffer.from(fichierTemp.buffer, 'base64'),
        idUser: req.body.idUser
    })
    .then(result => res.status(StatusCodes.CREATED).json({ 
        result: `Le document ${result["nom_fichier"]} est crée`
    }))
    .catch(error => res.status(StatusCodes.BAD_REQUEST).json({
        msg: error
    }))
})

const deleteDocuments = ((req, res) => {
    Documents.findByIdAndDelete({_id: req.params.idDoc})
    .then(result => res.status(200).json({ result }))
    .catch(error => res.status(500).json({msg: error}))
})

const modifyDocuments = ((req, res) => {
    Documents.findByIdAndUpdate(req.params.idDoc, req.body)
    .then(result => res.status(200).json({ message: `Le document ${result["nom_fichier"]} a été modifié.` }))
    .catch(error => res.status(500).json({msg: error}))
})

module.exports = { getDocumentsRecents, getListesDocuments, getListesDocumentsPDF, getListesDocumentsImages, getListesDocumentsWord, getListesDocumentsExcel, getDocumentById, postDocuments, deleteDocuments, modifyDocuments };