const express = require('express');
const { admin } = require('../../firebase-setup-admin');
const db = admin.firestore()
// const { getCollaboration } = require('./tasks-functions/Collaboration-Functions');

const collaborations = express.Router()

 collaborations.post("/collaborations",(req,res)=>{
    getCollaboration(req,res);
 })


 async function  getCollaboration(req,res) {
   
   var body = req.body
   var userEmail = body.email;
   console.log(`userEmail: ${JSON.stringify(body)}`);    
   

   const collectionReference = db.collection('/all_tasks');

   const snapshot = await collectionReference
   .where('people', 'array-contains',
   `${userEmail.toString()}`).get().catch(reason =>{console.log(`errr: ${reason}`);})

   if(typeof snapshot == "undefined"){
    console.log(`UNDEF 111`);    

       res.status(500).json({message:"Something went wrong",error:"An error occured",})      
   } else{
   if (snapshot.empty) {
    console.log(`userEmail: ${JSON.stringify(body)}`);    

       res.status(200).json(
        []
        //{message:"ok",error:null,data:[],}
        )

   }else{
       var results = snapshot.docs
        // return !(item.data()['people'].length < 1)}) //.data()

        const cleanedResults = []

        for (let index = 0; index < results.length; index++) {
             cleanedResults.push(results[index].data())                  
        }

      //  console.log(`RES: ${JSON.stringify(results)}`);
      //  results = results.filter(item => !(item.data()['people'].length < 1));
       res.status(200).json(
        // {message:"ok",error:null,data:
        cleanedResults
        // ,}
        )
     }
   }
}

 module.exports = collaborations
 