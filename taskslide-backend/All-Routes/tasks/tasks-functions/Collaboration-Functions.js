const TaskModel = require('../../../models/TaskModel')

function getCollaboration(req,res){
    var userEmail = req.query.email;
    TaskModel.find(
        {       
            // Or Query
          $or:[
                // email == userEmail AND people list is not empty
              {$and:[{creator:userEmail.toString()},{$expr:{$gt:[{$size:'$people'},0]}}]},
              { people : {$in:[userEmail.toString()]}}
          ]
        },
        (err,docs)=>{
        if(!err){
            //console.log(docs)
            res.json(docs)
        }else{
            //console.log(err);
            res.json([{"content":"err"}])
        }
    });
}

module.exports = {getCollaboration:getCollaboration,}
    


// {
//     // Or Query
//   $or:[
//         // email == userEmail AND people list is not empty
//       {$and:[{creator:userEmail.toString()},{ people : {$size: { $gt:0}}}]},
//       { people : {$in:[userEmail.toString()]}}
//   ]
// },



//{$expr:{$gt:[{$size:'$people'},-1]}},