const { admin } = require('../../firebase-setup-admin');
// const TaskSchema = require('../../models/TaskModel')
const db = admin.firestore()

async function SIOjoinRoomUpdateData_AndEmitDataToAll_InThisRoom(socketio,userSocket,incomingData,userSocketid){
    var theData = incomingData
    var roomName = `${theData.id}_${theData.creator}_${theData['date-time']}`;
    userSocket.join(roomName);

    const collectionReference = db.collection('/all_tasks');

    // Update the Database with the incoming data

    const snapshot = await collectionReference
    .where('creator', '==', theData.creator)
    .where('id', '==', theData.id)
    // .update(theData).catch(reason =>{console.log(`errr: ${reason}`);});
    .get().catch(reason =>{console.log(`errr: ${reason}`);});

    if(!(typeof snapshot == "undefined")){
        if(!(snapshot.empty)){
            var documentToUpdate = snapshot.docs.at(0).id
            console.log(`doc id: ${documentToUpdate}`)

            collectionReference
            .doc(documentToUpdate)
            .update(theData)
            .then((_)=>{
             /// Send the new updated data back to all 
            ///clients in this room listening on the event 'get_a_taskroom_event'
            getThisTaskAndUpdate(socketio,theData.creator,theData.id,roomName,userSocket);  
            })
            .catch(reason =>{})
        }

    }

    // TaskSchema.updateOne(
    //     {$and:[{creator:theData.creator,},{id:theData.id}]},
    //     theData,
    //     {upsert:true},
    //     (err,response)=>{
    //     if(!err){
           
    //         /// Send the new updated data back to all 
    //         ///clients in this room listening on the event 'get_a_taskroom_event'
    //         getThisTaskAndUpdate(socketio,theData.creator,theData.id,roomName,userSocket);
    //     }else{
    //         console.log(err);
    //     }
    // });
}

    /// Send the new updated data back to all clients 
   async function getThisTaskAndUpdate(socket,creatorid,taskid,room_name,usersocket){
        const collectionReference = db.collection('/all_tasks');

        const snapshot = await collectionReference
        .where('creator', '==', creatorid)
        .where('id', '==', taskid)
        .get()
        .catch(reason =>{console.log(`Login errr: ${reason}`);});
    
        if(!(typeof snapshot == "undefined")){
            console.log(`Sendingnback: werty`)
            //Send the new updated data back to all 
            //clients in this room listening on the event 'get_a_taskroom_event'
            //usersocket.to(room_name).emit("get_a_taskroom_event",JSON.stringify(docs))
            usersocket.broadcast.to(room_name).emit('get_a_taskroom_event', 
            // JSON.stringify(
                snapshot.docs
                //)
                );
        } 

    //     TaskSchema.find(
    //         {$and:[{creator:email,},{id:taskid}]},
    //         (err,docs)=>{
    //         if(!err){

    //         //Send the new updated data back to all 
    //         //clients in this room listening on the event 'get_a_taskroom_event'
    //         //usersocket.to(room_name).emit("get_a_taskroom_event",JSON.stringify(docs))
    //         usersocket.broadcast.to(room_name).emit('get_a_taskroom_event', JSON.stringify(docs));
            
    //        }
    // });        
}

module.exports ={
    SIOjoinRoomUpdateData_AndEmitDataToAll_InThisRoom:SIOjoinRoomUpdateData_AndEmitDataToAll_InThisRoom
}