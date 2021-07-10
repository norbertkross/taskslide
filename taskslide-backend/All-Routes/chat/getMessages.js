const express = require('express');
const ChatTaskModel = require('../../models/ChatTaskModel');

const readMessages = express.Router();

readMessages.post("/read_messages",(req,res)=>{
    var roomid = req.query.roomid || "okay"

    ChatTaskModel.find(
        {roomid:roomid.toString()})
        .sort({"datetime":"asc"}).exec((err,docs)=>{
            if(!err){
                res.json(docs)
            }else{
                res.json([])
            }
        });
})

module.exports = readMessages