const express = require('express')
const addNewTask = express.Router();

const { addnew } = require('./tasks-functions/new-task');

addNewTask.post("/addNewTask", async(req,res)=>{
    addnew(req,res);    
});

module.exports = addNewTask