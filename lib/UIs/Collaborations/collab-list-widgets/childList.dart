import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:taskslide/UIs/Collaborations/Dialogs/CollabCardTitleEditor.dart';
import 'package:taskslide/UIs/Collaborations/Dialogs/descriptionCollabDialog.dart';
import 'package:taskslide/UIs/CustomDialogBody/commentDescription.dart';
import 'package:taskslide/state/collaborationState.dart';
import 'package:taskslide/state/state.dart';

class CollaborationChildList extends StatefulWidget {
  final String header; 
  final String childkey;
  final String parentKey; 
  final String state;

  const CollaborationChildList({Key key, this.header, this.childkey, this.parentKey, this.state}) : super(key: key);
  
  @override
  _CollaborationChildListState createState() => _CollaborationChildListState();
}

class _CollaborationChildListState extends State<CollaborationChildList> {
  final childTaskState = Get.put(TaskState());
  final colllaborationState = Get.put(ColllaborationState());

  bool confirmDelete = false;

  @override
  Widget build(BuildContext context) {
    String color = colllaborationState.collabTaskList[num.parse(widget.parentKey)]["sub-children"] == null? "#0":  colllaborationState.collabTaskList[num.parse(widget.parentKey)]["sub-children"][num.parse(widget.childkey)]["color"];
    return Stack(
      children: [
        Column(
          children: [                 
          MouseRegion(
          cursor: SystemMouseCursors.click,
            child: Card(
              //color: childTaskState.taskList[num.parse(widget.parentKey)]["sub-children"][num.parse(widget.childkey)]["color"],
              shadowColor: Colors.transparent,
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Container(
                width: 300,
                child: Column(
                  children: [

                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                        color: color == "#0"? Colors.transparent : childTaskState.hexToColor(color),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),
                      ),
                      
                   SizedBox(height: 6,),
                                      
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:8.0),
                      child: Column(                                    
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                              GetBuilder<ColllaborationState>(
                              builder: (builder)=>      
                              Row(
                                children: [
                                  
                                  GestureDetector(
                                    onTap: (){

                                    int parentId = num.parse(widget.parentKey);
                                    int childId =  num.parse(widget.childkey);
                                    colllaborationState.checkItem(parentId,childId);
                                    
                                    },
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GetBuilder<ColllaborationState>(builder: (builder)=>
                                         Container(
                                          height: 17.0,
                                          width: 17.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4.0),
                                            border: Border.all(
                                              width: 1.5,
                                              color: colllaborationState.collabTaskList[num.parse(widget.parentKey)]["sub-children"][num.parse(widget.childkey)]["state"] == "done"?Theme.of(context).primaryColor : Theme.of(context).disabledColor.withOpacity(.15)),
                                          ),
                                          child: Center(
                                            child:colllaborationState.collabTaskList[num.parse(widget.parentKey)]["sub-children"][num.parse(widget.childkey)]["state"] == "done"? Icon(
                                            Icons.done,
                                            size: 15,color: Theme.of(context).primaryColor,
                                            ) : Container(),),
                                        ),
                                      ),
                                    ),
                                  ),
                              SizedBox(width: 6.0,),                                                  
                                ],
                               ),
                              ),                                                                                                
                             ],
                            ),
                              Flexible(
                                child: 
                                GetBuilder<ColllaborationState>(builder: (builder)=>
                                  Text(widget.header ?? "Task",
                                  style: TextStyle(
                                    decoration:colllaborationState.collabTaskList[num.parse(widget.parentKey)]["sub-children"][num.parse(widget.childkey)]["state"] == "done"? TextDecoration.lineThrough: TextDecoration.none,
                                  ),
                               ),
                                ),
                            ),

                             //showPencil == true && selectedId =="$key/sid/$parentKey"?  
                             Padding(
                                padding: const EdgeInsets.only(bottom: 8.0,left: 6.0),
                                child: Center(child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: (){
                                      colllaborationState.setSubChildrenPopUpIndex(num.parse(widget.childkey),num.parse(widget.parentKey));
                                      colllaborationState.setIsEditingProject(true);
                                    },
                                    child: Icon(Icons.more_vert_rounded,size: 18.0,color: Theme.of(context).disabledColor.withOpacity(.2),)),),),
                                    // child: Icon(Icons.edit,size: 18.0,color: Theme.of(context).disabledColor.withOpacity(.2),)),),),
                                ),
                              ],
                            ),
                        
                        SizedBox(height: 8.0,),
                        
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
        SizedBox(height: 6.0,),
          ],
        ),

      GetBuilder<ColllaborationState>(builder: (builder)=>
       num.parse(widget.childkey) == colllaborationState.subChildrenPopUpIndex
       &&
       num.parse(widget.parentKey) == colllaborationState.childListCurrentTouchParentKey
       ?  
         Card(
           elevation: 20,
          child: Container(
              width: 300,
              //height: 150,
              decoration: BoxDecoration(
                //color: Theme.of(context).cardColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 6,top: 4),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: (){
                              colllaborationState.setSubChildrenPopUpIndex(-1,-1);
                              colllaborationState.setIsEditingProject(false);
                            },
                            child: Container(
                              child: Icon(Icons.close,color: Theme.of(context).primaryColor,)),
                          )),
                      ),
                    ],
                  ),

                  SizedBox(height: 4,),
                  GestureDetector(
                    onTap: (){
                      colllaborationState.setSubChildrenPopUpIndex(-1,-1);
                      colllaborationState.editCardClicked(context,
                      child: CollabCardTitleEditer(
                        mainId: widget.parentKey,
                        subId: widget.childkey,
                        previousTitle: colllaborationState.collabTaskList[num.parse(widget.parentKey)]["sub-children"][num.parse(widget.childkey)]["name"],
                        previousColor: color,
                      ),);                    
                    },
                    child: MouseRegion(
                      cursor:SystemMouseCursors.click,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text("Edit",
                                    style: TextStyle(fontWeight: FontWeight.w600,color: Theme.of(context).disabledColor,),),
                                  ),
                                  Icon(Icons.edit,size: 18.0,color: Theme.of(context).disabledColor.withOpacity(.2),),                              

                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8),
                            child: Divider(
                              height: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                      colllaborationState.setSubChildrenPopUpIndex(-1,-1);
                      colllaborationState.buildEditDialog(
                      context,
                      child: CollabCommentDescription(
                        comment: colllaborationState.collabTaskList[num.parse(widget.parentKey)]["sub-children"][num.parse(widget.childkey)]["description"],
                        parent: widget.parentKey,
                        childKey: widget.childkey,
                      ),
                      );
                    },
                    child: MouseRegion(
                      cursor:SystemMouseCursors.click,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text("Description",
                                    style: TextStyle(fontWeight: FontWeight.w600,color: Theme.of(context).disabledColor,),),
                                  ),
                                  Icon(Icons.message_rounded,size: 18.0,color: Theme.of(context).disabledColor.withOpacity(.2),),                              

                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8),
                            child: Divider(
                              height: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                        setState(() {
                          confirmDelete = ! confirmDelete;                      
                      });
                    colllaborationState.setIsEditingProject(true);
                    },
                    child: MouseRegion(
                      cursor:SystemMouseCursors.click,
                      child: Column(
                        children: [
                        confirmDelete != true?  SizedBox(
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text("Delete",
                                    style: TextStyle(fontWeight: FontWeight.w600,color: Colors.redAccent.withOpacity(.7),),),
                                  ),
                                  Icon(Icons.delete_outline,size: 18.0,color: Colors.redAccent.withOpacity(.7),),                      
                                ],
                              ),
                            ),
                          ):Container(),

                      confirmDelete == true? Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          children: [
                            Text("  Delete?",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),),

                            SizedBox(width: 30,),

                             GestureDetector(
                              onTap: (){

                                colllaborationState.setSubChildrenPopUpIndex(-1,-1);
                                colllaborationState.deleteChildCardClick(num.parse(widget.parentKey),num.parse(widget.childkey),);
                                colllaborationState.setIsEditingProject(false);
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child:Text("Yes",style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),),
                        ),
                          ),),
                            SizedBox(width: 20.0,),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                confirmDelete = false;                                
                                });
                                colllaborationState.setIsEditingProject(false);
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text("No",style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ):Container(),                          

                        SizedBox(height: 12,),

                        ],
                      ),
                    ),
                  ),            

                  //SizedBox(height: 8,),
              ],),
            ),
        ):Container(),
      ),
      ],
    );
  }
}