const express = require('express')
const router = express.Router()

const { getDocumentsRecents, getListesDocuments, getListesDocumentsPDF, getListesDocumentsImages, getListesDocumentsWord, getListesDocumentsExcel, postDocuments, deleteDocuments, getDocumentById, modifyDocuments } = require('../controllers/documentsControllers');

const securite = require('../middleware/verifToken');

router.get('/recents/:userID', securite.checkJWT, getDocumentsRecents);
router.get('/listes/:userID', securite.checkJWT, getListesDocuments);
router.get('/listes/pdf/:userID', securite.checkJWT, getListesDocumentsPDF);
router.get('/listes/images/:userID', securite.checkJWT, getListesDocumentsImages);
router.get('/listes/word/:userID', securite.checkJWT, getListesDocumentsWord);
router.get('/listes/excel/:userID', securite.checkJWT, getListesDocumentsExcel);
router.get('/recup/:docID', securite.checkJWT, getDocumentById);
router.post('/', securite.checkJWT, postDocuments);
router.put('/modifDoc/:idDoc', securite.checkJWT, modifyDocuments);
router.delete('/suppDoc/:idDoc', securite.checkJWT, deleteDocuments);

module.exports = router;