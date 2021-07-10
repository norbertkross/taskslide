const TaskSchema = require('../../models/TaskModel')

function SIOjoinRoomUpdateData_AndEmitDataToAll_InThisRoom(socketio,userSocket,incomingData,userSocketid){
    var theData = incomingData
    var roomName = `${theData.id}_${theData.creator}_${theData['date-time']}`;
    userSocket.join(roomName);

    // Update the Database with the incoming data
    TaskSchema.updateOne(
        {$and:[{creator:theData.creator,},{id:theData.id}]},
        theData,
        {upsert:true},
        (err,response)=>{
        if(!err){
           
            /// Send the new updated data back to all 
            ///clients in this room listening on the event 'get_a_taskroom_event'
            getThisTaskAndUpdate(socketio,theData.creator,theData.id,roomName,userSocket);
        }else{
            console.log(err);
        }
    });
}

    /// Send the new updated data back to all clients 
    function getThisTaskAndUpdate(socket,email,taskid,room_name,usersocket){
        TaskSchema.find(
            {$and:[{creator:email,},{id:taskid}]},
            (err,docs)=>{
            if(!err){

            //Send the new updated data back to all 
            //clients in this room listening on the event 'get_a_taskroom_event'
            //usersocket.to(room_name).emit("get_a_taskroom_event",JSON.stringify(docs))
            usersocket.broadcast.to(room_name).emit('get_a_taskroom_event', JSON.stringify(docs));
            
           }
    });        
}

module.exports ={
    SIOjoinRoomUpdateData_AndEmitDataToAll_InThisRoom:SIOjoinRoomUpdateData_AndEmitDataToAll_InThisRoom
}