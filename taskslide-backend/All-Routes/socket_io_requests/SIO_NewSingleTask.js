    const TaskSchema = require('../../models/TaskModel')
    
     async function SIOgetAndSendDataBackToClient(socket,data,socketid){
        
       // var updateData = JSON.parse(data)

        var newData = data;

        var requestPromise = new Promise((resolve,reject)=>{

            TaskSchema.updateOne(
                {$and:[{creator:newData.creator,},{id:newData.id}]},
                //updateData,
                newData,
                {upsert:true},
                async (err,response)=>{
                if(!err){
                    //Get and send the data 
                 var finderPromiseComplete = await getThisTask(socket,newData.creator,newData.id,socketid);
                    resolve(finderPromiseComplete)
                }
            });

        });      
        
        return requestPromise;
    }



    function getThisTask(socket,email,taskid){

        var finderPromise = new Promise((resolve,reject)=>{

            TaskSchema.find(
                {$and:[{creator:email,},{id:taskid}]},
                (err,docs)=>{
                if(!err){
                    /// sending to individual send3er socketid
                    resolve(docs)
                   // socket.emit('server_sent_single_task', JSON.stringify(docs));
                }else{
                    reject(docs)
                }
            });            

        });  
        
        return finderPromise;
    }


    module.exports = {
        SIOgetAndSendDataBackToClient
    }