const express = require('express');
const TaskModel = require('../../models/TaskModel');

const collaborationsIamIn = express.Router();

collaborationsIamIn.post("/collaborations_i_am_in",(req,res)=>{
    var body = req.body
    var userEmail = body.userEmail || "none"
    
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
                res.json(docs)
            }else{
                res.json([])
            }
        }
    )
})

module.exports = collaborationsIamIn