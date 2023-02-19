import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskslide/state/state.dart';

import '../../state/collaborationState.dart';


class MediumBar extends StatefulWidget {
  @override
  _MediumBarState createState() => _MediumBarState();
}

class _MediumBarState extends State<MediumBar> {

  final colllaborationState = Get.put(ColllaborationState());
  final taskState = Get.put(TaskState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [

          SizedBox(height: 20.0,),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Your Projects",style: TextStyle(
              fontSize: 18.0,
              color: Theme.of(context).disabledColor,
              fontWeight: FontWeight.bold,
            ),),
          ),
                            
              // Textfield for name
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // height: 40.0,
                  decoration: BoxDecoration(
                    color:Theme.of(context).disabledColor.withOpacity(.06),
                    borderRadius: BorderRadius.circular(8.0,),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:0.0001,left: 4.0,right: 4.0),
                    // padding: const EdgeInsets.only(bottom:12.0,left: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical:0.0),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,  
                                hintText: "Search Project",                                   
                              ),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: (){

                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right:8.0),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Icon(Icons.search,color:Theme.of(context).disabledColor.withOpacity(.3))),
                          ),
                        ),

                      ],
                    ),
                  ),),
              ),


              // Projects List          
                            
              for(int projects=0; projects <= colllaborationState.collabAllTasks.length-1;projects++)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Obx(()=>
                     GestureDetector(
                       onTap: (){
                        colllaborationState.switchCurrentRunningProcess(projects);
                        taskState.switchPage(0);                         
                       },
                       child: Container(                    
                        decoration: BoxDecoration(
                          color: colllaborationState.currentCollabRunningProjectId.value == projects?Theme.of(context).primaryColor :Theme.of(context).primaryColor.withOpacity(.2),
                          borderRadius: BorderRadius.circular(8.0,),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom:0.0001,left: 4.0,right: 4.0),
                          // padding: const EdgeInsets.only(bottom:12.0,left: 4.0),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical:5.0,),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${colllaborationState.collabAllTasks[projects]["project-name"]}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).cardColor,
                                  ),),
                                ),
                              ),
                            ],
                          ),
                        ),),
                     ),
                  ),
                ),
              ),
           ],
      ),
    );
  }
}