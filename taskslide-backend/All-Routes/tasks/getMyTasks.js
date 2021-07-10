const express = require('express');
const myTasks = express.Router()
const TaskModel = require('../../models/TaskModel')

myTasks.post("/mytasks",(req,res)=>{
    console.log(req.query);
    const {email} = req.query;
    var userEmail = email;
    TaskModel.find({creator:  userEmail.toString()}).lean().exec((err,docs)=>{
        if(!err){
            //res.send(docs)
            //console.log(docs);
            res.send(docs)
            //console.log(docs);
        }else{
            res.json([])
        }
    });
})

module.exports = myTasks