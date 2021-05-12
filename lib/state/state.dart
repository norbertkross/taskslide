import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class TaskState extends GetxController{

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

List<Widget> currentPage = [
    
    TaskDragDrop(),
    CalenderAndDetails(),
    ChatHomeScreen(),
    Container(
      color: Colors.blue,
      width: 500,
      height: 500,
    ),
    CreatedProjects(),
];

var currentHomePageIndex = 4.obs;

var closeMediumBar = false.obs;

/// Construct a color from a hex code string, of the format #RRGGBB.
Color hexToColor(String code) {

  if(code.length >2){
    //print("Big Code: $code");
return Color(int.parse(code.substring(1, code.length), radix: 16) + 0xFF000000);
  }else{
     //print("Smaller Code: $code");
return Color(int.parse(code.substring(1, 2), radix: 16) + 0xFF000000);

  }
}

  // METHODS
  
void setRedorder(int oldIndex,int newIndex){
        if(oldIndex != items.length-1 && newIndex != items.length-1){
        Widget row = items.removeAt(oldIndex);
        items.insert(newIndex, row);

        // // Reorder Main List


        var holder;

        // var holdOld = taskList[oldIndex];

        // var holdNew = taskList[newIndex];

        holder = taskList[oldIndex];
        taskList[oldIndex] = taskList[newIndex];
        taskList[newIndex] = holder;
        // holdOld = holdNew;
        // holdNew = holdOld;

        // print("Type of Changed: ${taskList.runtimeType}");
        // //List changed = taskList.removeAt(oldIndex);
        // var changed = taskList.removeAt(oldIndex);
        // print("Type of Changed: ${changed.runtimeType}");
        // taskList.insert(newIndex, changed);
        generateList();
        update();
      } 
  }  

void addParentCard(String label){

var cardData =      
  // Single Task Item
   {
     "id":"${taskList.length}",
     "color": "#0",
     "name":"$label",
     "sub-children":[],
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

//void populateTasksList(){
//   
// }

void switchPage(int page){
     currentHomePageIndex.value = page;
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

        // var holdOld = taskList[oldIndex];

        // var holdNew = taskList[newIndex];

        holder = taskList[nthMain]["sub-children"][oldIndex];
        taskList[nthMain]["sub-children"][oldIndex] = taskList[nthMain]["sub-children"][newIndex];
        taskList[nthMain]["sub-children"][newIndex] = holder;

  // List newTaskList = taskList[nthMain]["sub-children"].removeAt(oldIndex);
  // taskList[nthMain]["sub-children"].insert(newIndex,newTaskList);

  generateList();
  update();
}


void reorderTasklist(_oldIndex,_newIndex,nPos){
      Widget row = childrenItems[nPos].removeAt(_oldIndex);
      childrenItems[nPos].insert(_newIndex, row); 
      update();
}

void clickedParentAddNew(String mainKeys){
      showChildInput.value = true; 
      currentInputIndex.value = "$mainKeys";              
      generateList();  
      //update();
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
}

void editChildCardDetailsClick(int mainIndex,int subIndex,{String name,String color}){
      taskList[mainIndex]["sub-children"][subIndex]["name"] = name;
      taskList[mainIndex]["sub-children"][subIndex]["color"] = color; 
      generateList();
      update();
}

void deleteChildCardClick(int mainIndex,int subIndex,){
      taskList[mainIndex]["sub-children"].removeAt(subIndex);
      generateList();
      update();
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
  }

  showInputToCreateTask(bool state){
    showFrontInput.value = state;
  }



  addNewProject({String name,String time}){

  List newItem = [{
   "id": 0,
   "project-name":"$name",
   "date-time":"$time",
   "date-start":"",
   "date-end":"",
   "people":[],
   "project-body":[],
     },
   ];

    var addMore = {
    "id": allTasks.length,
    "project-name":"$name",
    "date-time":"$time",
    "date-start":"",
    "date-end":"",
    "people":[],
    "project-body":[],
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
}
