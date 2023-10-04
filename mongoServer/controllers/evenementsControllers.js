const { StatusCodes } = require('http-status-codes');
const Evenements = require('../models/Evenements');
const Messages = require('../models/Messages');
const moment = require('moment');

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
    Evenements.create(
        {
            nom_event: req.body.nom_event,
            date_debut: moment(req.body.date_debut).toDate(),
            date_fin: moment(req.body.date_fin).toDate(),
            mode_event: req.body.mode_event,
            create_event: req.body.create_event,
            invite_prive: req.body.invite_prive
        }
    )
    .then(result => res.status(200).json({ result }))
    .catch(error => res.status(500).json({msg: error}))
})

const modifEvent = ((req, res) => {
    Evenements.findByIdAndUpdate(req.params.eventID, req.body)
    .then(result => res.status(200).json({ message: `Vous avez modifié l'évènement ${result["nom_event"]}` }))
    .catch(error => res.status(500).json({msg: error}))
})

const deleteEvents = ((req, res) => {
    Evenements.findByIdAndDelete({_id: req.params.eventID})
    .then(
        result => {
            if(result){
                try{
                    Messages.deleteMany({evenement: result["_id"]})
                    res.status(200).json({ message: "Vous avez supprimé l'évènement et les messages associés" })
                }
                catch(error){
                    res.status(500).json({ message: error })
                }
            }
        }
    )
    .catch(error => res.status(500).json({msg: error}))
});

const modifAccepInvite = ((req, res) => {
    const conditions = { _id: req.params.eventID, 'invite_prive.pseudo': req.body.pseudo}
    Evenements.findOneAndUpdate(conditions, { $set: { 'invite_prive.$.accept': true}}, { new: true }).select('invite_prive')
    .then(acceptValide => {
        if (acceptValide) {
            res.status(200).json({message: 'Vous avez validé l\'invitation.'});
        } else {
          res.status(500).json({msg: 'Vous n\'avez pas validé l\'invitation.'});
        }
      })
      .catch(error => {
        res.status(500).json({msg: error});
      });
});

const refusAccepInvite = ((req, res) => {
    const conditions = { _id: req.params.eventID, 'invite_prive.pseudo': req.body.pseudo}
    Evenements.findOneAndUpdate(conditions, { $pull: { invite_prive: { "pseudo": req.body.pseudo }}})
    .then(acceptRefus => {
        if (acceptRefus) {
            res.status(200).json({message: 'Vous avez refusé l\'invitation.'});
        }
      })
      .catch(error => {
        res.status(500).json({msg: error});
      });
});

const eventInvitePrive = ((req, res) => {
    Evenements.aggregate([{
        $match: {
            $or: [
                { mode_event: 'public' },
                { $and: [
                    { mode_event: 'prive' },
                    { $or: [
                        { create_event: req.body.createEvent },
                        { invite_prive: {
                            $elemMatch: {
                                pseudo: req.body.pseudoEvent,
                                accept: true,
                            }
                        }},
                    ]}
                ]}
            ]
        },
    }])
    .then(result => res.status(200).json({ result }))
    .catch(error => res.status(500).json({msg: error}))
});

const arrayPseudoEventPrive = ((req, res) => {
    try{
        Evenements.find({_id: req.params.eventID})
        .then(result => {
            if (result) {
                const arrayPseudo = result.reduce((acc, event) => {
                    event.invite_prive.forEach((invite) =>{
                        if(invite.accept){
                            acc.push({id: invite._id, display: invite.pseudo});
                        }
                    })
                    return acc;
                }, []);
                res.status(StatusCodes.OK).json({ result: arrayPseudo });
            }
          })
          .catch(error => {
            res.status(StatusCodes.BAD_REQUEST).json({msg: error});
          });        }
    catch(error) {
        res.status(StatusCodes.BAD_REQUEST).json({error: error})
    }
});

module.exports = { getEvents, getOneEvent, eventsCreate, deleteEvents, modifAccepInvite, eventInvitePrive, refusAccepInvite, modifEvent, arrayPseudoEventPrive };