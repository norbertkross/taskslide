const mongoose = require('mongoose')

const chatSchema = mongoose.Schema({
    roomid:{type:String,require:true},
    username:String,
    senderid:String,
    message:{type:String,trim:true},
    messagetype:{type:String,default:"message"},
    contenttype:{type:String,default:"string"},
    isreply:{type:Boolean,default:false},
    replyBody:{type:String},
    datetime: {type:Date,default: Date.now}
});

module.exports = mongoose.model("ChatSchema",chatSchema);