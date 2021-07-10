const express = require('express');
const ChatTaskModel = require('../../models/ChatTaskModel');

const newChatMessage = express.Router();

newChatMessage.post("/chat_message",(req,res)=>{
    var requestQuery = req.query || {
        roomid:"019833",
        username:"norbertaberor",
        senderid:"norbertaberor@gmail.com",
        message:"I am a string on your screen",
        messagetype:"message",
        contenttype:"string",
        isreply:false,
        replyBody:"",
    }
    
    var message = new ChatTaskModel(requestQuery)

    message.save((err,result)=>{
        if(!err){
            res.json({
                response:"okay",
            })
        }else{
            res.json({
                response:"error",
            })  
        }
    })


})

module.exports = newChatMessage