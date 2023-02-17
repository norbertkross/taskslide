const express = require('express');
// const mongoose = require('mongoose')
const app = express();
const server = require('http').createServer(app)
// Socket IO server
const socketio = require('socket.io')(server)

require('dotenv/config')

app.use(express.json());
app.use(express.urlencoded({extended: true}));

var cors = require('cors')


// Custom Imports
// const addNewTaskRoute = require('./All-Routes/tasks/AddNewTask');
// const myTasks = require('./All-Routes/tasks/getMyTasks');
const collaborations = require('./All-Routes/tasks/collaborations');
const saveProject = require('./All-Routes/tasks/saveUserProject');
const { SIOgetAndSendDataBackToClient } = require('./All-Routes/socket_io_requests/SIO_NewSingleTask');
const { SIOjoinRoomUpdateData_AndEmitDataToAll_InThisRoom } = require('./All-Routes/socket_io_requests/SIOcollaborationRoom');
const newChatMessage = require('./All-Routes/chat/sendChatMessage');
const readMessages = require('./All-Routes/chat/getMessages');
// const collaborationsIamIn = require('./All-Routes/chat/collaborationsIamIn');
const addNewProject = require('./All-Routes/tasks/CRUD_Operations/_project/create_project');
const GetMyProjetcs = require('./All-Routes/tasks/CRUD_Operations/_project/_get_my_projects');

// mongoose.connect(process.env.MONGO_DB_CONNECTION.toString(),{ useNewUrlParser: true,useUnifiedTopology: true,},(error)=>{
//    console.log("The connection erro",error); 
//    console.log(`Connected To DB Succesfully @ : ${process.env.MONGO_DB_CONNECTION}`);
// })


  // Enable CORS
  app.use(cors())

  app.get("/",(req,res)=>{
     res.send("<h3>Hello Welcome to</h3> <h1>Taskslide </h1>")
  });

//   app.use(addNewTaskRoute);
  app.use(addNewProject); // &ok

//   app.use(myTasks)
  app.use(GetMyProjetcs) // &ok

  app.use(collaborations) // &ok

  app.use(saveProject)  // &ok

  app.use(newChatMessage) // ***

  app.use(readMessages)  // ***

//   app.use(collaborationsIamIn)

  app.get("*",(req,res)=>{
     res.send("<h1>Not Found</h1>")
  });


  
  // REALTIME FUNCTIONALITY with SOCKET.IO
  
  socketio.on("connection", (userSocket) => {

           // A Single User Has Updated A list Item 
           userSocket.on("client_sent_task", async (data,callback) =>{
            var results = await SIOgetAndSendDataBackToClient(socketio,data,userSocket.id,callback);
            callback(results)
           });


           /// A User Has Updated A List Item In A Group Collaboration[]
           userSocket.on("join_a_taskroom", (incomingData,callback) =>{
            SIOjoinRoomUpdateData_AndEmitDataToAll_InThisRoom(socketio,userSocket,incomingData,userSocket.id);
            var acknowledgement = `${incomingData["date-time"]}-${incomingData.id}-${incomingData.creator}`;
            callback(acknowledgement)
          });
          
          // Add User to a taskroom
          userSocket.on("join_room",(data)=>{
             var pareseData = JSON.parse(data)
             console.log(`user joined room: ${pareseData['room_id']}`);
             userSocket.join(pareseData["room_id"].toString());
          })

       });

  // host environment
  const myhostPort = process.env.PORT || 3000

  server.listen(myhostPort)
