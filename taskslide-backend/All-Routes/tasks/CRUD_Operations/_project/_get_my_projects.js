const express = require('express');
const { admin } = require('../../../../firebase-setup-admin');
const GetMyProjetcs = express.Router();
const db = admin.firestore()

GetMyProjetcs.post("/my_projects", async(req,res)=>{
   
    var body = req.body
    
    const collectionReference = db.collection('/all_tasks');

    const snapshot = await collectionReference
    .where('creator', '==',body.userid)
    .get().catch(reason =>{console.log(`Login errr: ${reason}`);})

    if(typeof snapshot == "undefined"){
        res.status(500).json({message:"Something went wrong",error:"An error occured",})      
    } else{
    if (snapshot.empty) {
        res.status(200).json({message:"ok",error:null,data:[],})
    }else{
        var results = snapshot.docs[0].data()
        res.status(200).json({message:"ok",error:null,data:results,})
    }
    }       
});


module.exports = GetMyProjetcs