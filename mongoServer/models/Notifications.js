const mongoose = require("mongoose");
const notificationSchema = new mongoose.Schema({
    evenements: {
        type: String,
    },
    type_notif: {
        type: String,
    },
    message_notif: {
        type: String,
    },
    destin_notif: {
        type: String,
    }
},{ timestamps: true });
module.exports = mongoose.model("Notifications", notificationSchema);