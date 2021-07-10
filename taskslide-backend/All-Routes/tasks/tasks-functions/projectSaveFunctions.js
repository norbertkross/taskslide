const TaskModel = require('../../../models/TaskModel')

function save_my_project(req,res){

    const wholeProject = req.query.project!= "" ? JSON.parse(req.query.project) : [];    

       var allUserProjects = wholeProject.map((value,index)=>{

            return {
                updateOne:{
                    filter:{$and:[{creator:wholeProject[index]['creator'],},{id:wholeProject[index]['id'].toString()}]},
                    update:wholeProject[index],
                    upsert:true,
                }
              };            
            });

       TaskModel.bulkWrite(allUserProjects)
       .then((promise)=>{
           console.log(promise)
           res.send({"msg":"Successful"})

       })
       .catch((err)=>{
           console.log(err);
           res.send({"msg":"there was an error"})
       });
}

module.exports = {
    save_my_project:save_my_project,
}