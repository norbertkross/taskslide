   const TaskSchema = require('../../../models/TaskModel')
   
   function addNewTask(req,res){
        var id = req.query.id.toString();
        var creator = req.query.creator.toString();
        var projectName = req.query['project-name'].toString();
        var dateTime = req.query['date-time'].toString();
        var dateStart = req.query['date-start'].toString();
        var dateEnd = req.query['date-end'].toString();
        var done = req.query.done.toString();
        var peopleList = req.query.people != "" ? JSON.parse(req.query.people) : [];
        var projectBody = req.query['project-body']!= "" ? JSON.parse(req.query['project-body']) : [];    
    
        
        var updateContent = {
            id:id,
            creator: creator,
            "project-name": projectName,
            "date-time": dateTime,
            "date-start": dateStart,
            "date-end": dateEnd,
            people: peopleList,
            "project-body": projectBody,
            done:done,
        };
    
        TaskSchema.updateOne(
            {$and:[{creator: creator,},{id:id}]},
            updateContent,
            {upsert:true},
            (err,response)=>{
            if(!err){
                res.send(response)
            }else{
                //console.log(err);
                res.send({"msg":"err"})
            }
        });        
    }


module.exports = {
    addnew:addNewTask,
}    