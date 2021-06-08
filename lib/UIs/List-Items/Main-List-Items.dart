import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:reorderables/reorderables.dart';
import 'package:taskslide/UIs/CustomDialogBody/CardTitleEditer.dart';
import 'package:taskslide/state/state.dart';

class MainListItem extends StatefulWidget {
final String header; 
final String mainKeys;
final int nPos;

  const MainListItem({Key key, this.header, this.mainKeys, this.nPos}) : super(key: key);

  @override
  _MainListItemState createState() => _MainListItemState();
}

class _MainListItemState extends State<MainListItem> {

  final taskState = Get.put(TaskState());

  @override
  Widget build(BuildContext context) {
    String color = taskState.taskList == null? "#0": taskState.taskList[num.parse(widget.mainKeys)]["color"];

    return Padding(
      key:ValueKey("${widget.mainKeys}"),
        padding: const EdgeInsets.all(12.0),
          child: Obx((){      
           //taskState.generateList();
           return Container(
            //padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color:taskState.themeMode.value != true?
            Theme.of(context).disabledColor.withOpacity(.03) :
              // Colors.black.withOpacity(.08) :
            Theme.of(context).disabledColor.withOpacity(.03),
            ),
            child: SizedBox(
              width: 300.0,
              child: Column(
                children: [
                       
                        Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color:color == "#0"? Colors.transparent : taskState.hexToColor(color),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                          ),
                        ),

                  SizedBox(height: 4.0,),

                  Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Flexible(
                            child: Container(
                              child: 
                                GetBuilder<TaskState>(builder: (builder)=>
                                 Text(taskState.processHeader(widget.header),style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:Theme.of(context).disabledColor.withOpacity(.6),
                                  fontSize: 18.0,
                                ),),),
                          ),),

                        Row(
                          children: [
                          Container(
                            height: 20.0,
                            width: 20.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).disabledColor.withOpacity(.12),
                            ),
                            child: Center(child: Text("${taskState.taskList[widget.nPos]["sub-children"].length}"),),
                          ),

                          GestureDetector(
                            onTap: (){
                              taskState.editCardClicked(
                                context,
                                child: CardTitleEditer(
                                  mainId: widget.mainKeys,
                                  previousTitle: taskState.taskList[num.parse(widget.mainKeys)]["name"],
                                  previousColor:  color,
                                ),);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal:2.0),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Icon(Icons.more_horiz,color: Theme.of(context).disabledColor,)),
                            ),
                          ),                                    
                          ],
                        ),

                        ],),

                      SizedBox(height: 8.0,),              


                      GetBuilder<TaskState>(
                        builder: (builder)=>
                        ReorderableColumn(
                          children: taskState.childrenItems[widget.nPos] != null?
                            taskState.childrenItems[widget.nPos]: 
                            (<Widget>[
                            Container(
                              height: 30,
                              color: Colors.redAccent,
                              width: 60.0,
                              key: UniqueKey(),
                            ),
                          ]), 
                        onReorder: (int _oldIndex,int _newIndex){

                        taskState.parentReorder(_oldIndex, _newIndex, widget.nPos);
                        taskState.reorderSubTaskList( widget.nPos,oldIndex: _oldIndex,newIndex: _newIndex,);

                    },
            ),),


                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [


                             GetBuilder<TaskState>(
                               builder: (builder)=>
                                GestureDetector(
                                 onTap:(){
                                     taskState.hasFinishedProject(num.parse(widget.mainKeys));
                                   },
                                 child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Tooltip(
                                    message: "Finished",
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Container(
                                        width: 23,
                                        height: 23,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          color:taskState.taskList[num.parse(widget.mainKeys)]['done'] == true?Color(0xff12ec24).withOpacity(.15) :Theme.of(context).disabledColor.withOpacity(.06),
                                         ),
                                        child:Icon(Icons.done_rounded,size: 20.0,
                                        color:taskState.taskList[num.parse(widget.mainKeys)]['done'] == true?Color(0xff12ec24).withOpacity(.5) : Theme.of(context).disabledColor.withOpacity(.08),),
                                        ),
                                    ),
                                  ),
                            ),
                               ),
                             ),

                            GestureDetector(
                              onTap: (){    
                               //setState(() {
                                 taskState.clickedParentAddNew(widget.mainKeys);                        
                              //});                             
                               
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8,right: 8,top: 12,bottom: 4),//(horizontal:8.0,vertical: 12.0),
                                  child:
                                     Text("Add new +",style: TextStyle(
                                        color:
                                        //taskState.themeMode.value == true?  
                                        Theme.of(context).primaryColor
                                        //Theme.of(context).disabledColor.withOpacity(.2)
                                        ,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        decoration: TextDecoration.underline,
                                    ),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          );},
        ),
      );
  }
}