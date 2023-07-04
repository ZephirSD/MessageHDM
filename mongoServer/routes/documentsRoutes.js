const express = require('express')
const router = express.Router()

const { getDocumentsRecents, getListesDocuments, postDocuments, deleteDocuments, getDocumentById } = require('../controllers/documentsControllers');

const securite = require('../middleware/verifToken');

router.get('/recents/:userID', securite.checkJWT, getDocumentsRecents);
router.get('/listes/:userID', securite.checkJWT, getListesDocuments);
router.get('/recup/:docID', securite.checkJWT, getDocumentById);
router.post('/', securite.checkJWT, postDocuments);
router.delete('/:idDoc', securite.checkJWT, deleteDocuments);

module.exports = router;