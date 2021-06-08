import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskslide/UIs/Collaborations/Collaborations.dart';
import 'package:taskslide/UIs/CreatedProjectsHome/CreatedProjects.dart';
import 'package:taskslide/UIs/CustomDialogBody/CustomBodyDialog.dart';
import 'package:taskslide/UIs/chat/ChatHomeScreen.dart';
import 'package:taskslide/UIs/home/calenderAndDetails.dart';
import 'package:taskslide/UIs/home/taskDragDrop.dart';
import 'package:taskslide/UIs/List-Items/Child-Cards-List.dart';
import 'package:taskslide/UIs/List-Items/Input-And-Button.dart';
import 'package:taskslide/UIs/List-Items/Input-Child-Items.dart';
import 'package:taskslide/UIs/List-Items/Main-List-Items.dart';
import 'dart:convert';

// Importing this with prefix to fix multiple packages error
import 'package:dio/dio.dart' as packageDio;

// SOCKET.IO client
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:taskslide/state/BaseUrl.dart';

class TaskState extends GetxController{

  @override
  void onInit(){
    connectAndListen();
  }

  // DECLARSRIONS   

List allTasks = [].obs;

List taskList = [].obs;  

List<Widget> items = []..obs;

List childrenItems = []..obs;

var showInput = false.obs;

var showFrontInput = false.obs;

var showChildInput = false.obs;

var currentInputIndex = "currentid".obs;

var feelingLucky = false.obs;

var themeMode = false.obs;

var offlineMode = false.obs;

var currentRunningProjectId = 0.obs;

var subChildrenPopUpIndex = -1..obs;

var childListCurrentTouchParentKey = -1..obs;


List<Widget> currentPage = [
    
    TaskDragDrop(),
    CalenderAndDetails(),
    ChatHomeScreen(),
    Collaborations(),
    CreatedProjects(),
];

var currentHomePageIndex = 4.obs;

var closeMediumBar = false.obs;

var messageQue = [].obs;

var isSavingProject = false.obs;

  IO.Socket socket = IO.io( BaseUrl.baseUrl,
      IO.OptionBuilder()
       .setTransports(['websocket']).build());


/// METHODS

/// Construct a color from a hex code string, of the format #RRGGBB.
Color hexToColor(String code) {
  if(code.length >2){
return Color(int.parse(code.substring(1, code.length), radix: 16) + 0xFF000000);
  }else{
return Color(int.parse(code.substring(1, 2), radix: 16) + 0xFF000000);

  }
}


void setRedorder(int oldIndex,int newIndex){
        if(oldIndex != items.length-1 && newIndex != items.length-1){
        Widget row = items.removeAt(oldIndex);
        items.insert(newIndex, row);

        // // Reorder Main List
        var holder;

        holder = taskList[oldIndex];
        taskList[oldIndex] = taskList[newIndex];
        taskList[newIndex] = holder;
        generateList();
        update();
        sendTaskToServer();
      }

  // Send Updates to server if the user has turned on online sync
  if(offlineMode.value == true){sendTaskToServer();}       
  }  

void addParentCard(String label){

var cardData =      
  // Single Task Item
   {
     "id":"${taskList.length}",
     "color": "#0",
     "name":"$label",
     "sub-children":[],
     'done':false,
   };

    taskList.add(cardData);
          generateList();
}

void addChildToParent(int maxN,{String header, String description}){
  // A Task Child Item
  var childData = {
         "id":"${taskList[maxN]["sub-children"].length}",
         "color": "#0",
         "state":"waiting",  
         "name":"$header",
         "description":"$description",
         "people":[
           {"person-id":"id110",
            "profile-pic":"",
           }
         ]
       };

       taskList[maxN]["sub-children"].add(childData);
          generateList();
}

void generateList({bool isInit}){
    
    List<Widget> children = [];

      if(childrenItems.length > 0) {childrenItems = [];}

      if(items != null) items = [];

      if( taskList != null )

      for(int n=0; n<=taskList.length-1;n++){        
        
        children = [];

        for(int sub = 0; sub<=taskList[n]["sub-children"].length-1; sub++){
          children.add(
            CardWidget(
              //key:UniqueKey(),
              key: ValueKey("$sub/k/$n"),
              header: taskList[n]["sub-children"][sub]["name"].toString(),
              childkey: sub.toString(),
              parentKey: taskList != null?n.toString():"0",
              state: taskList[n]["sub-children"][sub]["state"].toString(),
            ),
          );

        if(sub == taskList[n]["sub-children"].length-1){
          children.add(
             InputChildItems(key: UniqueKey(),thisParentId: n.toString())
            );
          }
      }     

      // add inputfield Anyways if there are no items  

      if(taskList[n]["sub-children"].length == 0){
           children.add(
             InputChildItems(key: UniqueKey(),thisParentId: n.toString())
          ); 
      }       
                                
      childrenItems.insert(n, children);
      
      items.add(
        MainListItem(
          nPos: n,
          header:taskList !=null?taskList[n]["name"].toString():"Aberor",
          mainKeys: n.toString(),
          key: UniqueKey(),
         ),
       );

        if(n == taskList.length-1){
          items.add(
             InputAndButton(key:UniqueKey(),)
            );
          }
       }

    // add Button Anyways if there are no items
         if(taskList.length == 0){
          // print("Items Zero, adding Button");
           items.add(
             InputAndButton(
               key:UniqueKey(),
             )
            );
          }

  // I want the method to only run if its not 
  // being called when the app is being Initialized
   if(isInit != true){
      storeValuesLocally(taskList);
   }else{
     print("Was initializes...");
   }   

}

void hasFinishedProject(int parentid,){

  if(taskList[parentid]['done'] == true){
      taskList[parentid]['done'] = false;
    }else{
      taskList[parentid]['done'] = true;
  }  
  update();
  // Send Updates to server if the user has turned on online sync
  if(offlineMode.value == true){sendTaskToServer();}

 }

void addToDescription({String comment,int parent,int childkey}){
  taskList[parent]["sub-children"][childkey]["description"] = comment;
  generateList();

  // Send Updates to server if the user has turned on online sync
  if(offlineMode.value == true){sendTaskToServer();}

}

//void populateTasksList(){
//   
// }

void switchPage(int page){
     currentHomePageIndex.value = page;
     update();
  }


 void storeValuesLocally(List mainlist)async{

  allTasks[currentRunningProjectId.value]["project-body"] = mainlist;

   SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      var myToJson = jsonEncode(allTasks);
      // var myToJson = jsonEncode(myAllItems);
      await prefs.setString('main-list', myToJson); 
         //print(myToJson) ;
  
    }catch (e){
     // print(e);
   }
   // print("...saved new data to diskly");
 }

 void storeLocalValuesFromProjectHome()async{
       try{
   SharedPreferences prefs = await SharedPreferences.getInstance();
      var myToJson = jsonEncode(allTasks);
      await prefs.setString('main-list', myToJson); 
        //print(myToJson) ;
  
    }catch (e){
      //print(e);
   }
 }

  void getAndSetTaskValues({bool isInit})async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var values = (prefs.getString('main-list') ?? jsonEncode([]) );
  var castedToList = json.decode(values);
   allTasks.clear();
   allTasks = castedToList;
    taskList =  allTasks.length > 0? allTasks[currentRunningProjectId.value]["project-body"] : [];
   generateList(isInit: isInit);
   update();

  }

  String processHeader(String text){
    if(text.length<30){
    return text;  
    }else{  
    return text.substring(0,27) + " ...";
    }
  }

void parentReorder(_oldIndex,_newIndex,nPos){
      Widget row = childrenItems[nPos].removeAt(_oldIndex);
      childrenItems[nPos].insert(_newIndex, row); 
      update();
}

void reorderSubTaskList(int nthMain,{oldIndex,newIndex}){

      var holder;

    holder = taskList[nthMain]["sub-children"][oldIndex];
    taskList[nthMain]["sub-children"][oldIndex] = taskList[nthMain]["sub-children"][newIndex];
    taskList[nthMain]["sub-children"][newIndex] = holder;

  generateList();
  update();

  // Send Updates to server if the user has turned on online sync
  if(offlineMode.value == true){sendTaskToServer();}
}


void reorderTasklist(_oldIndex,_newIndex,nPos){
      Widget row = childrenItems[nPos].removeAt(_oldIndex);
      childrenItems[nPos].insert(_newIndex, row); 
      update();
}

void clickedParentAddNew(String mainKeys){
      showChildInput.value = true; 
      // The index which you want to show this input for
      currentInputIndex.value = "$mainKeys";              
      generateList();  
      //update();

  // Send Updates to server if the user has turned on online sync
  if(offlineMode.value == true){sendTaskToServer();}
      
}

void callToAddChildToParent(int maxN,{String header, String description}){
      showChildInput.value = false;       
      addChildToParent(maxN,header: header,description: description);  
      update();
}

void callToAddParent(String input){
        showInput.value = false; 
        addParentCard(input); 
        update();
  // Send Updates to server if the user has turned on online sync
  if(offlineMode.value == true){sendTaskToServer();}

}

void callToCloseParentAddition(){
      showInput.value = false;    
      generateList();
}

void addToParentButton(){
      showInput.value = true;  
      generateList();
}

void childListClose(){
      currentInputIndex.value = "currentid"; 
      showChildInput.value = false;   
      generateList();
}


void checkItem(int nth,int subnth){
      if(taskList[nth]["sub-children"][subnth]["state"] == "done"){
      taskList[nth]["sub-children"][subnth]["state"] = "waiting";  
      }else{
        taskList[nth]["sub-children"][subnth]["state"] = "done";
      }
      generateList();
      update();

  // Send Updates to server if the user has turned on online sync
  if(offlineMode.value == true){sendTaskToServer();}

}

void editCardClicked(BuildContext context,{Widget child,}){
    buildEditDialog(context,child: child);
}

void editCardUpdateClick(int index,{String name,String color}){
      taskList[index]["name"] = name;
      taskList[index]["color"]  = color; 
      generateList();
      update();      
}

void editProjectTitle(int index,String newTitle){
    allTasks[index]["project-name"] = newTitle;
    generateList();  
    update();
}

void setDateRange(int index,{String start,String end}){ 
    allTasks[index]["date-start"] = "$start";
    allTasks[index]["date-end"] = "$end";
    generateList();
    update();
}

void deleteParentCardClick(int index){
      taskList.removeAt(index);
      generateList();
      update();

  // Send Updates to server if the user has turned on online sync
  if(offlineMode.value == true){sendTaskToServer();}

}

void editChildCardDetailsClick(int mainIndex,int subIndex,{String name,String color}){
      taskList[mainIndex]["sub-children"][subIndex]["name"] = name;
      taskList[mainIndex]["sub-children"][subIndex]["color"] = color; 
      generateList();
      update();

  // Send Updates to server if the user has turned on online sync
  if(offlineMode.value == true){sendTaskToServer();}

      
}

void deleteChildCardClick(int mainIndex,int subIndex,){
      taskList[mainIndex]["sub-children"].removeAt(subIndex);
      generateList();
      update();

  // Send Updates to server if the user has turned on online sync
  if(offlineMode.value == true){sendTaskToServer();}

}


void buildEditDialog(BuildContext context,{Widget child,String mainId,String subId}){
    Navigator.of(context).push(      
      PageRouteBuilder(
      opaque: false,
      pageBuilder: (pageBuilder,__,_)=>CustomBodyDialog(child: child,)),);
}


 setThemeMode()async{
  themeMode.value = !themeMode.value;
  try{
   SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('theme', themeMode.value);   
    }catch (e){}
 }

 getThemeMode()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  themeMode.value = (prefs.getBool('theme') ?? false);   
 }


  setOfflineMode(bool newbool)async{
    offlineMode.value = newbool;
    try{
    SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('offlineMode', offlineMode.value);   
      }catch (e){}
  }

 getOfflineMode()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  offlineMode.value = (prefs.getBool('offlineMode') ?? false);   
 }

  setFeelingLuckyMode()async{
    feelingLucky.value = !feelingLucky.value;
    try{
    SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('feeling', feelingLucky.value);   
      }catch (e){}
  }

 getFeelingLuckyMode()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  feelingLucky.value = (prefs.getBool('feeling') ?? false);   
 }


  switchCurrentRunningProcess(int newid){
    currentRunningProjectId.value = newid;
    taskList = allTasks[currentRunningProjectId.value]["project-body"];
    generateList();
    update();
  }

  closeTheMediumBar({bool value}){
    closeMediumBar.value = value ?? !closeMediumBar.value;
    update();
  }

  showInputToCreateTask(bool state){
    showFrontInput.value = state;
  }



  void setSubChildrenPopUpIndex(newint,parentkey){
    subChildrenPopUpIndex = newint;
    childListCurrentTouchParentKey = parentkey;
    //generateList();
    update();
  }  


  addNewProject({String name,String time}){

  List newItem = [
    {
   "id": 0,
   "creator":"norbertaberor@gmail.com",
   "project-name":"$name",
   "date-time":"$time",
   "date-start":"",
   "date-end":"",
   "people":[],
   "project-body":[],
   'done':false,
    },
  ];


    var addMore = {
    "id": allTasks.length,
    "creator":"norbertaberor@gmail.com",
    "project-name":"$name",
    "date-time":"$time",
    "date-start":"",
    "date-end":"",
    "people":["eugene@mail.yup","johnaturkhim@ymail.nert"],
    "project-body":[],
    'done':false,
    };

   //print("Length of all files: ${allTasks.length}");

  if(allTasks.length == 0){
     allTasks = newItem;
       
    }else{       
      allTasks.add(addMore);
    }
    //print(allTasks);
    update();
  }


  Map<String,dynamic> returnSingleTaskItem(){

   var id = allTasks.length>0?allTasks[currentRunningProjectId.value]["id"].toString():"";

   var creator = allTasks.length>0?allTasks[currentRunningProjectId.value]["creator"].toString():"";

   var projectName =allTasks.length>0?allTasks[currentRunningProjectId.value]["project-name"].toString():"";

   var dateTime = allTasks.length>0?allTasks[currentRunningProjectId.value]["date-time"].toString():"";

   var dateStart = allTasks.length>0? allTasks[currentRunningProjectId.value]["date-start"].toString():"";

   var dateEnd = allTasks.length>0?allTasks[currentRunningProjectId.value]["date-end"].toString():"";

   var people = allTasks.length>0? allTasks[currentRunningProjectId.value]["people"]:"";

   var peopleEncoded = allTasks.length>0?people:"";

   var projectBody = allTasks.length>0? allTasks[currentRunningProjectId.value]["project-body"]:"";

   var projectBodyEncoded =  allTasks.length>0? projectBody:"";

    Map<String,dynamic> queryParams = {
      "id":id,
      'creator': creator,
      'project-name':projectName,
      'date-time':dateTime,
      'date-start':dateStart,
      'date-end':dateEnd,
      'people': peopleEncoded,
      'project-body':projectBodyEncoded,  
      'done':false,
      };

    return queryParams;
  }


/// HTTP REQUESTS


  /// Get All Tasks for this users email
   getAllMyTask({String email})async{
    packageDio.Dio dio = packageDio.Dio();
    var url = BaseUrl.baseUrl +'/mytasks';
    Map<String,dynamic> queryParams = {
      "email": email,
      };

    var response = await dio.post(url,queryParameters: queryParams,);
    var data = response.data;
    var check = data[0]["creator"];
    print(check.runtimeType);
    //print(data[0]["creator"].runtimeType);      
   }
   
/// Get all Tasks that the user is collaborating in
   getCollaborations({String email})async{
    packageDio.Dio dio = packageDio.Dio();
    var url = BaseUrl.baseUrl+'/collaborations';
    Map<String,dynamic> queryParams = {
      "email": email,      
      };

    var response = await dio.post(url,queryParameters: queryParams,).catchError((err){
        print(err);
    });
    
    print(response.data); 
   }
   
   
  /// Get All Tasks for this users email
   saveWholeProjectOnline({String email})async{
    packageDio.Dio dio = packageDio.Dio();
    var url = BaseUrl.baseUrl+'/save-project';
    Map<String,dynamic> queryParams = {
      "project": json.encode(allTasks),      
      };

    var response = await dio.post(url,queryParameters: queryParams,);
    
    print(response.data);      
   }


   // SocketIO
 void connectAndListen(){
    socket.onConnect((_) {
     print('connected ...v/');
    });

   ///When a single task event is recieved from server,
   ///data is added to the Tasklist Locally
    socket.on('server_sent_single_task', (data){
      var dataDecoded = json.decode(data);
      print("server_sent_single_task");
      print(dataDecoded);
    });


    /// This user recieves data from the server.The data is from a 
    /// particular thask room which user has joined with ['join_a_taskroom']
    socket.on('get_a_taskroom_event', (data){
      var dataDecoded = json.decode(data);
      print("get_a_taskroom_event");
      print(dataDecoded);
    });

    /// When the Socket has disconnected
    socket.onDisconnect((_) => print('disconnect'));

}

 /// This would add a User to A collaboration Task room So that user can recieve 
 /// all event Emitted by the socket to ['get_a_taskroom_event']
 void joinTaskRoomToUpdateAndSendData({Map<String,dynamic> data,}){
   socket.emit('join_a_taskroom',json.encode(data),);
 }


 /// Emit the event ['client_sent_task'] so that user listening on
 /// ['server_sent_single_task'] can recieve it.
  void emitSingleTask(){

    Map<String,dynamic> queryParams = returnSingleTaskItem();

     socket.emit('client_sent_task',
     json.encode(queryParams),);      

 }

  void clearMessageQue(){
      messageQue.clear();
  }

 // Send task with Acknowledgements
  void sendTaskToServer(){

    isSavingProject.value = true;

    String id = returnSingleTaskItem()["id"].toString();
    String dateTime = returnSingleTaskItem()["date-time"].toString();
    String creator = returnSingleTaskItem()["creator"].toString();

    Map<String, dynamic> newTaskList = returnSingleTaskItem();
    //newTaskList["ack"] = "$dateTime-$id-$creator";
    //print(newTaskList);

         socket.emitWithAck('join_a_taskroom',newTaskList,
        // Ackknowledgement
        ack: (results){
          isSavingProject.value = true;

            /// When the server acknowledges that it has recieved this data
            /// remove this unique details from the [MessagesQue] of item
            /// which are waiting to be deliverd
            messageQue.remove(results.toString());
            print("Messaging Que2 $messageQue");
          },
        ); 

        /// This socket request is sent add this inique details to the [MessageQue] list
        messageQue.add("$dateTime-$id-$creator");
        print("Messaging Que1: $messageQue");
        
  }

 // Send task with Acknowledgements
  void sendCollaborationTaskToServer(){

    isSavingProject.value = true;

    String id = returnSingleTaskItem()["id"].toString();
    String dateTime = returnSingleTaskItem()["date-time"].toString();
    String creator = returnSingleTaskItem()["creator"].toString();

    Map<String, dynamic> newTaskList = returnSingleTaskItem();
    //newTaskList["ack"] = "$dateTime-$id-$creator";
    //print(newTaskList);

         socket.emitWithAck('join_a_taskroom',newTaskList,
        // Ackknowledgement
        ack: (results){
          isSavingProject.value = true;

            /// When the server acknowledges that it has recieved this data
            /// remove this unique details from the [MessagesQue] of item
            /// which are waiting to be deliverd
            messageQue.remove(results.toString());
            print("Messaging Que2 $messageQue");
          },
        ); 

        /// This socket request is sent add this inique details to the [MessageQue] list
        messageQue.add("$dateTime-$id-$creator");
        print("Messaging Que1: $messageQue");
        
  }

  // /addNewTask

/// Store Updates in a database
  //  sendUpdateData()async{    


  //   packageDio.Dio dio = packageDio.Dio();
  //   var url = BaseUrl.baseUrl+'/addNewTask';
  //   Map<String,dynamic> queryParams = returnSingleTaskItem();

  //   var response = await dio.post(url,queryParameters: queryParams,);
    
  //   print(response.data);

  //  }
}
