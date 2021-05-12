import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:reorderables/reorderables.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:taskslide/UIs/Extras/offline-switch.dart';
import 'package:taskslide/state/state.dart';

class TaskDragDrop extends StatefulWidget {
  final String id;

  const TaskDragDrop({Key key, this.id}) : super(key: key);
  @override
  _TaskDragDropState createState() => _TaskDragDropState();
}

class _TaskDragDropState extends State<TaskDragDrop> {

// DECLARATIONS
  final taskState = Get.put(TaskState());
  double smallDevice = 650.0;


// EAEBEE - main body
// F4F5F7 - Items cards body
// E6E7E7 - circle avatar colo
// FEFFFE - Card color


@override
void initState() { 
  super.initState();
  print(taskState.currentRunningProjectId);
}

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
                          Tooltip(message: "I'm feeling lucky",
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: (){
                                taskState.setFeelingLuckyMode();
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Theme.of(context).primaryColor.withOpacity(.001),
                                child: Stack(
                                  children: [                                 
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20,left: 25),
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15,left: 8),
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.yellow,
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 20,left: 17),
                                      child: Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff1a4ff7),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 12,left: 30),
                                      child: Container(
                                        width: 7,
                                        height: 7,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xfff78f1a),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 12,left: 19),
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF0aab20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ),

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
                          onPressed: (){}
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
            child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (__){
            __.disallowGlow();
            return false;
            },
            child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width < smallDevice ? (mq.width < 350 ? mq.width + 100 : mq.width + 5) : 1800.0,
                    child: Obx(()=>
                       Stack(
                        children: [

                      taskState.feelingLucky.value == true? CircularParticle(
                          key: ValueKey("CircularParticle"),
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width < smallDevice ?  (mq.width < 350 ? mq.width + 100 : mq.width + 5)  : 1800.0,
                          awayRadius: 80, 
                          numberOfParticles: 200,
                          speedOfParticles: 1,

                          onTapAnimation: true,
                          particleColor: Colors.white,
                          awayAnimationDuration: Duration(milliseconds: 800),
                          maxParticleSize: 5,
                          isRandSize: true,
                          isRandomColor: true,
                          randColorList: [
                            Colors.red,
                            Color(0xff1a4ff7),
                            Color(0xfff78f1a),                
                            Colors.yellow,
                            Color(0xFF0aab20),
                          ],
                          awayAnimationCurve: Curves.easeInOutBack,
                          enableHover: true,
                          hoverColor: Colors.white,
                          hoverRadius: 90,
                          connectDots: false, //not recommended 
                        ):Container(),

                          ListView(
                            children: [
                              // Main List Body
                              
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
                              )
                            ),
                          ),
                        ),
            ),
          ),
        ],
      ),
                );
              }
            }

