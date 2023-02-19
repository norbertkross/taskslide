const express = require('express');
const { admin } = require('../../../../firebase-setup-admin');
const addNewProject = express.Router();
const db = admin.firestore()

addNewProject.post("/add_new_project", async(req,res)=>{
    addnew(req,res);    
});


   
function addnew(req,res){
    var data = req.body
    console.log(`DTAT: ${JSON.stringify(data)}`)
    const docReference = db.collection('/all_tasks').doc();

    docReference.set(data)
    .then(done=>{         
      res.status(200).json({message:"Successfully created a new user project",error:null,data:data,db_response:done})
    })
    .catch(reason =>{
      // console.log(`There was an error: ${reason}`);
      res.status(400).json({message:"Something went wrong",error:reason.toString(),})
    });         
}



module.exports = addNewProject
