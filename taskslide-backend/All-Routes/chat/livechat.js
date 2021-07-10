const ChatTaskModel = require('../../models/ChatTaskModel');
    
async function SIOlivechat(socket,data,socketid){
   
  // var updateData = JSON.parse(data)

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

   var newData = data;

   var message = new ChatTaskModel(requestQuery)

   var roomname = 

   message.save((err,docs)=>{
       if(!err){
            getThisTask(socket,newData.creator,newData.id,socketid);
       }
       else{
            console.log(`There was an error: ${err}`);
       }
   });
}



function getThisTask(socket,email,taskid){

    ChatTaskModel.find(
           {$and:[{creator:email,},{id:taskid}]},
           (err,docs)=>{
           if(!err){
               /// sending to all send3er socketid
               usersocket.broadcast.to(room_name).emit('livechat', JSON.stringify(docs));
            }else{
               console.log(`There was an error`);
           }
       });  
}


module.exports = {
    SIOlivechat
}