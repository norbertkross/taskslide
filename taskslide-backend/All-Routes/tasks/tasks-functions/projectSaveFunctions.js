const { admin } = require('../../../firebase-setup-admin');
// const TaskModel = require('../../../models/TaskModel')
const db = admin.firestore()


async function save_my_project(req,res){

    var body = req.body
    const wholeProject = body.project; 
       
    // Get a new write batch
    const batch = db.writeBatch()

    for (let index = 0; index < wholeProject.length; index++) {
        const docReference = db.collection('/all_tasks').where('creator', '==',wholeProject[index]['creator']).where('id', '==',wholeProject[index]['id'].toString());
        batch.set(docReference, wholeProject[index],{ merge: true });  
    }


    // Commit the batch
    await batch.commit();

    // var allUserProjects = wholeProject.map((value,index)=>{
    //     // Set the value of 'NYC'
    //     return          
    //     });

    // return {
    //     updateOne:{
    //         filter:{$and:[{creator:wholeProject[index]['creator'],},{id:wholeProject[index]['id'].toString()}]},
    //         update:wholeProject[index],
    //         upsert:true,
    //     }
    //   };     

    //    TaskModel.bulkWrite(allUserProjects)
    //    .then((promise)=>{
    //        console.log(promise)
    //        res.send({"msg":"Successful"})

    //    })
    //    .catch((err)=>{
    //        console.log(err);
    //        res.send({"msg":"there was an error"})
    //    });
}

module.exports = {
    save_my_project:save_my_project,
}