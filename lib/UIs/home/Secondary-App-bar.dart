import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskslide/UIs/Extras/offline-switch.dart';
import 'package:taskslide/state/collaborationState.dart';
import 'package:taskslide/state/state.dart';
class SecondaryAppBar extends StatefulWidget {
  @override
  _SecondaryAppBarState createState() => _SecondaryAppBarState();
}

class _SecondaryAppBarState extends State<SecondaryAppBar> {
  final taskState = Get.put(TaskState());
  final colllaborationState = Get.put(ColllaborationState());
  double smallDevices = 650.0;
  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Container(
      child: mq.width > smallDevices? Card(
              elevation: 20.0,
              margin: EdgeInsets.all(0.0),
              child: Container(
                width: 65.0,
                height: mq.height,
                color: Theme.of(context).cardColor,
                child: ListView(
                  children: [
                    Column(
                      children: [

                        SizedBox(
                        height: 15,
                         ),
                        //   child:
                          Tooltip(
                            message: "Online Sync",
                            child: MouseRegion(
                              cursor:SystemMouseCursors.click,
                              child: Obx(() =>
                                WSRectSwitch(
                                  activeColor: Theme.of(context).primaryColor,
                                  value: taskState.offlineMode.value,
                                  onChanged: (_){
                                    taskState.setOfflineMode(_);
                                  },
                                ),
                              ),
                            ),
                          ),  
                           SizedBox(
                            height: 8,
                          ),

                          Obx(
                            ()=> Text("offline",style: TextStyle(
                              color: colllaborationState.isOnline.value ==true? Colors.transparent:  Colors.red,
                            ),),
                          ),                      

                      SizedBox(
                        height: 12,
                      ),
                      

                        IconButton(
                        tooltip: "People",
                        icon: Icon(
                          Icons.people,color: Theme.of(context).disabledColor,), 
                        onPressed: (){}
                        ),

                        SizedBox(height: 10,),

                        IconButton(
                        tooltip: "Theme",
                        icon: Icon(
                          Icons.brightness_6,color: Theme.of(context).disabledColor,), 
                        onPressed: (){
                          taskState.setThemeMode();
                        }
                        ),

                        SizedBox(height: 10,),                       
                          
                        Obx(()=>
                        (taskState.offlineMode.value == true) 
                        || (taskState.currentHomePageIndex.value == 3 && colllaborationState.isEditing.value == true)?
                           Obx(()=>
                              Tooltip(
                               message:taskState.messageQue.isNotEmpty? "Save Project" :"Already Saved",
                               child: MouseRegion(
                                 cursor: SystemMouseCursors.click,
                                 child: GestureDetector(
                                   onTap: (){
                                     if(taskState.currentHomePageIndex.value == 3){
                                      /// You're editing a collaboration project                                      
                                          if(colllaborationState.isEditing.value == true){
                                            /// The User is editing a collaborative project
                                          }else{
                                            /// The User is in collaboratione page but not editing a single task
                                          }

                                     }else if(taskState.currentHomePageIndex.value == 0){
                                      /// You're editing a user project                                      
                                          if(taskState.currentHomePageIndex.value == 0){
                                              // editing a single project item 
                                              taskState.clearMessageQue();
                                              taskState.sendTaskToServer();
                                          }else{
                                            // in the homepage 
                                          }
                                     }
                                   },
                                   child: Container(
                                    child: Obx(()=>
                                      Text(taskState.isSavingProject.value == true? "saving": "Save",style: TextStyle(
                                        color: Theme.of(context).cardColor,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 6,  ),
                                    decoration: BoxDecoration(
                                      color: taskState.messageQue.length != 0? Color(0xff5cdd41):
                                      Theme.of(context).disabledColor.withOpacity(.1),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                          ),
                                 ),
                               ),
                             ),
                           ):Container(),
                        ),
                        //),                        
                      ],
                    ),
                  ],
                ),
              ),
            ):Container(),
    );
  }
}