const express = require('express');
const { getCollaboration } = require('./tasks-functions/Collaboration-Functions');

const collaborations = express.Router()

 collaborations.post("/collaborations",(req,res)=>{
    getCollaboration(req,res);
 })

 module.exports = collaborations
 