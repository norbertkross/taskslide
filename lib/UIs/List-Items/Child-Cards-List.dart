import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:taskslide/UIs/CustomDialogBody/CardTitleEditer.dart';
import 'package:taskslide/state/state.dart';

class CardWidget extends StatefulWidget {
  final String header; 
  final String childkey; 
  final String parentKey; 
  final String state;

  const CardWidget({Key key, this.header, this.childkey, this.parentKey, this.state}) : super(key: key);
  
  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  final childTaskState = Get.put(TaskState());

  @override
  Widget build(BuildContext context) {
    String color = childTaskState.taskList[num.parse(widget.parentKey)]["sub-children"] == null? "#0":  childTaskState.taskList[num.parse(widget.parentKey)]["sub-children"][num.parse(widget.childkey)]["color"];
    return Column(   
    //key: ValueKey("${widget.childkey}/k/${widget.parentKey}"), 
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
                    height: 8,
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

                          GetBuilder<TaskState>(
                          builder: (builder)=>      
                          Row(
                            children: [
                              
                              GestureDetector(
                                onTap: (){

                                int parentId = num.parse(widget.parentKey);
                                int childId =  num.parse(widget.childkey);
                                childTaskState.checkItem(parentId,childId);
                                
                                },
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Container(
                                    height: 17.0,
                                    width: 17.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      border: Border.all(
                                        width: 1.5,
                                        color:widget.state == "done"?Theme.of(context).primaryColor : Theme.of(context).disabledColor.withOpacity(.15)),
                                    ),
                                    child: Center(
                                      child:widget.state == "done"? Icon(
                                      Icons.done,
                                      size: 15,color: Theme.of(context).primaryColor,
                                      ) : Container(),),
                                  ),
                                ),
                              ),
                          SizedBox(width: 6.0,),                                                  
                            ],
                            ),
                          ),                                                                                                
                            ],
                          ),
                          Flexible(child: Text(widget.header ?? "Study Android and Kotlin",
                          style: TextStyle(
                            decoration:widget.state == "done"? TextDecoration.lineThrough: TextDecoration.none,
                          ),
                          ),),

                         //showPencil == true && selectedId =="$key/sid/$parentKey"?  
                         Padding(
                            padding: const EdgeInsets.only(bottom: 8.0,left: 6.0),
                            child: Center(child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: (){
                                  childTaskState.editCardClicked(context,
                                  child: CardTitleEditer(
                                    mainId: widget.parentKey,
                                    subId: widget.childkey,
                                    previousTitle: childTaskState.taskList[num.parse(widget.parentKey)]["sub-children"][num.parse(widget.childkey)]["name"],
                                    previousColor: color,
                                  ),);
                                },
                                child: Icon(Icons.edit,size: 18.0,color: Theme.of(context).disabledColor.withOpacity(.2),)),),),
                            ),
                          ],
                        ),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right:8.0,top: 2),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Icon(Icons.message,color: Theme.of(context).disabledColor.withOpacity(.15),size: 20.0,)),
                        ),

                        Flexible(child: Wrap(
                          children: [
                          Container(
                            width: 18.0,
                            height: 18.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Theme.of(context).disabledColor.withOpacity(.15)),
                            ),
                            child: Center(
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Icon(
                                Icons.person,
                                color: Theme.of(context).disabledColor.withOpacity(.15),size: 16.0,
                                ),
                              ),
                            ),
                          ),],
                        ),),
                      ],
                    ),
                    SizedBox(height: 12.0,),
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
    );
  }
}