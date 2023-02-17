import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reorderables/reorderables.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:taskslide/state/collaborationState.dart';
import 'package:taskslide/state/state.dart';

class CollaborationTaskEditor extends StatefulWidget {

  const CollaborationTaskEditor({Key key}) : super(key: key);
  @override
  _CollaborationTaskEditorState createState() => _CollaborationTaskEditorState();
}

class _CollaborationTaskEditorState extends State<CollaborationTaskEditor> {

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
            width: mq.width,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
              child: Wrap(
                children: [
                Padding(
                  padding: EdgeInsets.only(left: 12.0,right: 12.0,),
                  child: SizedBox(
                    width: mq.width,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: (){
                              // taskState.switchPage(4);
                              taskState.closeTheMediumBar();

                              },
                            child: RotatedBox(quarterTurns: 2,
                              child: Icon(taskState.closeMediumBar.value == false?Icons.chevron_left_rounded: Icons.chevron_right_rounded,
                            size: 30,
                              color: Theme.of(context).primaryColor),
                            ),),),                      

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
                                     if(taskState.currentHomePageIndex.value == 3){
                                      /// You're editing a collaboration project                                      
                                          if(collaborationState.isEditing.value == true){
                                            /// The User is editing a collaborative project
                                          }else{
                                            /// The User is in collaboratione page but not editing a single task
                                          }

                                     }else if(taskState.currentHomePageIndex.value == 0){
                                      /// You're editing a user project                                      
                                          if(taskState.currentHomePageIndex.value == 0){
                                              // editing a single project item 
                                              //taskState.sendTaskToServer();
                                          }else{
                                            // in the homepage 
                                          }
                                     }
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
                                                  
                          SizedBox(width: 16,),

                        ],
                      ),
                      ],
                    ),
                  ),
                ),
                ],
              ),
            ),
            ):Row(
              children: [
                Container(
                  child: SizedBox(
                    width: mq.width,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        SizedBox(width: 12,),
                        Tooltip(
                          message: "Home",
                          child: GestureDetector(
                            onTap: (){
                              taskState.closeTheMediumBar();
                              // collaborationState.swtichEditingMode(value: false);
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Obx(()=>Icon(
                            taskState.closeMediumBar.value == false?Icons.chevron_left_rounded: Icons.chevron_right_rounded,
                            size: 30,
                            color: Theme.of(context).primaryColor,)),

                              // Icon(Icons.arrow_back,
                              //   size: 30,
                              //   color: Theme.of(context).primaryColor,),
                                ),
                            ),
                        ),                 
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
          Flexible(
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
                                            GetBuilder<ColllaborationState>(
                                            builder: (builder)=>
                                             ReorderableWrap(
                                              children:
                                             collaborationState.collabItems != null?
                                               collaborationState.collabItems: 
                                               (<Widget>[
                                                Container(                                
                                                  key: UniqueKey(),),
                                              ]), 
                                              onReorder:collaborationState.setRedorder
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
        ],
      ),
                );
              }
            }

