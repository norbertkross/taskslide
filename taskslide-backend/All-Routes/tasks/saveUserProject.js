const express = require('express');
const {save_my_project} = require('./tasks-functions/projectSaveFunctions')

const saveProject = express.Router();

    saveProject.post("/save-project",(req,res)=>{
        save_my_project(req,res);
    });

    module.exports = saveProject