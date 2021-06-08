import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:taskslide/state/collaborationState.dart';
import 'package:taskslide/state/state.dart';

class CollaborationInputChildItems extends StatefulWidget {
  final String thisParentId;

  const CollaborationInputChildItems({Key key, this.thisParentId}) : super(key: key);

  @override
  _CollaborationInputChildItemsState createState() => _CollaborationInputChildItemsState();
}

class _CollaborationInputChildItemsState extends State<CollaborationInputChildItems> {
  final childTaskState = Get.put(TaskState()); 
  final colllaborationState = Get.put(ColllaborationState()); 

  final TextEditingController subChildHeaderController = TextEditingController();
  String get subChildHeaderInput => subChildHeaderController.text; 

  final TextEditingController subChildDescriptionController = TextEditingController();
  String get subChildDescriptionInput => subChildDescriptionController.text; 

  @override
  Widget build(BuildContext context) {
    return Column(
      //key: UniqueKey(),
      children: [
        Obx(()=>
          Column(      
          children: [
            colllaborationState.showChildInput.value == true && colllaborationState.currentInputIndex.value ==  widget.thisParentId?
            Card(
              shadowColor: Colors.transparent,
              elevation: 20.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                width: 300.0,
                child: Column(
                  children: [

                    //items Textfieled 
                    Container(
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: subChildHeaderController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "New item...",
                            hintStyle: TextStyle(
                              color: Theme.of(context).disabledColor.withOpacity(.3),
                            ),
                          ),
                        ),
                      ),
                    ),

                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 0.0),
                      child: Container(
                        height: 1.5,
                        color: Theme.of(context).primaryColor.withOpacity(.5),
                        //width: ,
                      ),
                    ),

                    // Message Textfieled
                    SizedBox(
                      height: 32,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: subChildDescriptionController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Description...",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).disabledColor.withOpacity(.3),
                            ),
                          ),
                        ),
                      ),
                    ),


                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0,right: 8.0,),
                        child: Container(
                          color: Theme.of(context).primaryColor.withOpacity(.05),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left:4.0),
                                  child: Transform.rotate(
                                  angle: -2.1,
                                  child: Icon(Icons.attachment_outlined,
                                  color:Theme.of(context).disabledColor.withOpacity(.4),size: 20.0,),
                                  ),
                                ),

                                SizedBox(width: 2.0,),

                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("Attach File",style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).disabledColor.withOpacity(.3),
                                  ),),
                                ),
                                
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),


                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0,right: 8.0,),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: (){
                                //setState(() {
                                  // currentInputIndex = "currentid"; 
                                  // showChildInput = false;   
                                  // generateList(taskList); 
                                  // });
                                  colllaborationState.childListClose();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Icon(Icons.close,color: Theme.of(context).disabledColor,),
                                ),
                              ),
                            ),                            

                            SizedBox(width: 2.0,),
                           MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: (){
                                  if(subChildHeaderInput.trim().isNotEmpty){
                                    //print(subChildHeaderInput);
                                    int pid = num.parse(widget.thisParentId);
                                                                                                                                                                               
                                    colllaborationState.callToAddChildToParent(
                                      pid,
                                      header: subChildHeaderInput,
                                      description:subChildDescriptionInput,
                                    );

                                    subChildHeaderController.clear();
                                    subChildDescriptionController.clear();
                                  }
                                },
                                child: Container(
                                  height: 30.0,
                                  width: 65.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Center(
                                    child: Text("Add",style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).canvasColor,
                                    ),),
                                  ),
                                ),
                              ),
                            ),                          
                            SizedBox(height: 12.0,),                            
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ) : Container(),
           ],
          ),
        ),
      ],
    );
  }
}