    const { admin } = require('../../firebase-setup-admin');
    const db = admin.firestore()

// const TaskSchema = require('../../models/TaskModel')
    
     async function SIOgetAndSendDataBackToClient(socket,data,socketid){
        const collectionReference = db.collection('/all_tasks');

        var requestPromise = new Promise(async (resolve,reject)=>{

            const snapshot = await collectionReference
            .where('creator', '==', data.creator)
            .where('id', '==', data.id)
            // .update(data).catch(reason =>{console.log(`errr: ${reason}`);});
            .get(data).catch(reason =>{console.log(`errr: ${reason}`);});

            if(!(typeof snapshot == "undefined")){

                if(!(snapshot.empty)){
                    var documentToUpdate = snapshot.docs.at(0).id
        
                    collectionReference
                    .doc(documentToUpdate)
                    .update(theData)
                    .then(async(_)=>{
                     //Get and send the data 
                var finderPromiseComplete = await getThisTask(socket,data.creator,data.id,socketid);
                resolve(finderPromiseComplete)   
                    })
                    .catch(reason =>{})
                }
                
            }

            

            // TaskSchema.updateOne(
            //     {$and:[{creator:newData.creator,},{id:newData.id}]},
            //     //updateData,
            //     newData,
            //     {upsert:true},
            //     async (err,response)=>{
            //     if(!err){
            //         //Get and send the data 
            //      var finderPromiseComplete = await getThisTask(socket,newData.creator,newData.id,socketid);
            //         resolve(finderPromiseComplete)
            //     }
            // });

        });      
        
        return requestPromise;
    }



    function getThisTask(socket,creatorid,taskid){

        var finderPromise = new Promise(async(resolve,reject)=>{
            const collectionReference = db.collection('/all_tasks');

            const snapshot = await collectionReference
            .where('creator', '==', creatorid)
            .where('id', '==', taskid)
            .get()
            .catch(reason =>{console.log(`Login errr: ${reason}`);});
        
            if(typeof snapshot == "undefined"){
                // res.status(500).json({message:"Something went wrong",error:"An error occured",})  
                reject([])
    
            } else{
              /// sending to individual send3er socketid
                resolve(snapshot.docs)        
            }

            // TaskSchema.find(
            //     {$and:[{creator:email,},{id:taskid}]},
            //     (err,docs)=>{
            //     if(!err){
            //         /// sending to individual send3er socketid
            //         resolve(docs)
            //        // socket.emit('server_sent_single_task', JSON.stringify(docs));
            //     }else{
            //         reject(docs)
            //     }
            // });            

        });  
        
        return finderPromise;
    }


    module.exports = {
        SIOgetAndSendDataBackToClient
    }