import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reorderables/reorderables.dart';
import 'package:taskslide/UIs/Extras/offline-switch.dart';
import 'package:taskslide/state/collaborationState.dart';
import 'package:taskslide/state/state.dart';

class TaskDragDrop extends StatefulWidget {

  const TaskDragDrop({Key key}) : super(key: key);
  @override
  _TaskDragDropState createState() => _TaskDragDropState();
}

class _TaskDragDropState extends State<TaskDragDrop> {

// DECLARATIONS
  final taskState = Get.put(TaskState());
  final collaborationState = Get.put(ColllaborationState());

  double smallDevice = 650.0;

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
         
         MediaQuery.of(context).size.width < smallDevice ? Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
              child: Wrap(
                children: [
                Padding(
                  padding: EdgeInsets.only(left: 12.0,right: 12.0,),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                 
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: (){taskState.switchPage(4);},
                            child: Icon(Icons.home_rounded,size:30,
                            color: Theme.of(context).primaryColor),),),                      

                      Wrap(       
                        crossAxisAlignment: WrapCrossAlignment.center,                
                        children: [
                          
                          IconButton(
                          tooltip: "Theme",
                          icon: Icon(
                            Icons.brightness_6,
                            size: 25,
                            color: Theme.of(context).disabledColor,), 
                          onPressed: (){
                            taskState.setThemeMode();
                          }
                          ),

                          SizedBox(width: 10,),

                          IconButton(
                          tooltip: "People",
                          icon: Icon(
                            Icons.people,size: 27,color: Theme.of(context).disabledColor,), 
                          onPressed: (){ }
                          ),                                                            
                          SizedBox(width: 16,),

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
                          SizedBox(width: 12,),
                        Obx(()=>
                        (taskState.offlineMode.value == true) 
                        || (taskState.currentHomePageIndex.value == 3 && collaborationState.isEditing.value == true)?
                           Obx(()=>
                              Tooltip(
                               message:taskState.messageQue.isNotEmpty? "Save Project" :"Already Saved",
                               child: MouseRegion(
                                 cursor: SystemMouseCursors.click,
                                 child: GestureDetector(
                                   onTap: (){
                                     taskState.sendTaskToServer();
                                   },
                                   child: Container(
                                    child: Text("Save",style: TextStyle(
                                      color: Theme.of(context).cardColor,
                                      fontWeight: FontWeight.bold,
                                    ),),
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
                                                                                                             
                        ],
                      ),

                      ],
                    ),
                  ),
                ),
                ],
              ),
            ),
            ):Container(
              child: SizedBox(
                width: mq.width,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [

                    Tooltip(
                      message: "Hide/Show Panel",
                      child: GestureDetector(
                        onTap: (){
                           taskState.closeTheMediumBar();
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Obx(()=>Icon(
                            taskState.closeMediumBar.value == false?Icons.chevron_left_rounded: Icons.chevron_right_rounded,
                            size: 30,
                            color: Theme.of(context).primaryColor,))),
                        ),
                    ),
                    SizedBox(width: 8,),
                    Padding(
                    padding:EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top,left: 8.0),
                    child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                    onTap: (){taskState.switchPage(4);},
                    child: Icon(Icons.home_rounded,size:30,
                    color: Theme.of(context).primaryColor),
                     ),
                    ),
                   ),                  
                  ],
                ),
              ),
            ),
            
          Flexible(
            child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width < smallDevice ? (mq.width < 350 ? mq.width + 100 : mq.width + 5) : 1800.0,
                    child: 
                       Stack(
                        children: [
            
                          ListView(
                            children: [
                              
                                  Wrap(
                                    alignment: mq.width < smallDevice && mq.width > 550.0? WrapAlignment.center : WrapAlignment.start,
                                    children: [
                                          Container(
                                            child:                                      
                                            GetBuilder<TaskState>(
                                            builder: (builder)=>
                                             ReorderableWrap(
                                              children:
                                             taskState.items != null?
                                               taskState.items: 
                                               (<Widget>[
                                                Container(                                
                                                  key: UniqueKey(),),
                                              ]), 
                                              onReorder:taskState.setRedorder
                                              ),
                                             ),
                                           ),                          
                                        ],
                                      ),  
                                      SizedBox(height: 30,),
                                    ],
                                  ),
                                ],                              
                            ),
                          ),
                        ),
          ),
        ],
      ),
                );
              }
            }

