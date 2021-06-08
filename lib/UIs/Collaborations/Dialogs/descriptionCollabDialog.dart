import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:taskslide/state/collaborationState.dart';
import 'package:taskslide/state/state.dart';

class CollabCommentDescription extends StatefulWidget {
  final String comment;
  final String parent;
  final String childKey;

  const CollabCommentDescription({Key key,this.comment, this.parent, this.childKey}) : super(key: key);

  @override
  _CollabCommentDescriptionState createState() => _CollabCommentDescriptionState();
}

class _CollabCommentDescriptionState extends State<CollabCommentDescription> {

  //final taskState = Get.put(TaskState());
  final colllaborationState = Get.put(ColllaborationState());

  TextEditingController _controller;

  bool showEditField = false;

  @override
  void initState(){
    print(widget.comment);
    _controller = TextEditingController(text: "${widget.comment}"); 
    super.initState();
  }  

  @override
  Widget build(BuildContext context) {
    return  Padding(
            padding: const EdgeInsets.symmetric(vertical: 16,),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                width: 220.0,
                child: Column(
                  children: [

                    SizedBox(height: 10),

                    SizedBox(
                      width: 220,
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0,right:8.0),
                            child: Text("Description",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10,),

                    SizedBox(
                      width: 220,
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0,right:8.0),
                            child: Text("${_controller.text.trim().isNotEmpty? colllaborationState.collabTaskList[num.parse(widget.parent)]["sub-children"][num.parse(widget.childKey)]["description"] : "No comment yet" }",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color:_controller.text.trim().isNotEmpty? Theme.of(context).primaryColor :  Theme.of(context).primaryColor.withOpacity(.4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  showEditField == true?  
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 6),
                      child: Container(
                        height: 33,
                        decoration: BoxDecoration(
                          color: Theme.of(context).disabledColor.withOpacity(.1),
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        child: TextField(
                          controller: _controller,
                           decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8,right: 8,bottom: 10),//(horizontal: 8.0),
                             hintText: "${_controller.text.trim().isNotEmpty?"":"add comment"}",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ): Container(),
                    
                    SizedBox(height: 4.0,),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                    //showEditField == true? 
                    GestureDetector(
                      onTap: (){
                           if(showEditField == false){
                             Navigator.pop(context);
                           }else{
                          setState(() {
                             showEditField = false;                             
                          });                             
                           }
                        
                      },
                      child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                        child: Padding(
                          padding: const EdgeInsets.only(right:8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.red.withOpacity(.2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 6),
                              child: Icon(Icons.close,
                              size: 18,color: Colors.red,),
                            ),
                          ),
                        ),
                      ),
                    )
                    //:Container()
                    ,
                     GestureDetector(
                      onTap: (){
                        // show editing field
                        if(showEditField == false){
                            setState(() {
                             showEditField = ! showEditField;                             
                          });
                        }else{
                          // Update description

                          colllaborationState.addToDescription(
                          comment: _controller.text,
                          parent: num.parse(widget.parent),
                          childkey: num.parse(widget.childKey));
                          setState(() {
                             showEditField = ! showEditField;                             
                          });
                          Navigator.pop(context);
                        }
                        
                      },
                      child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                        child: Padding(
                          padding: const EdgeInsets.only(right:8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Theme.of(context).primaryColor.withOpacity(.2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 6),
                              child: Icon(showEditField == false? Icons.edit : Icons.done,size: 18,color: Theme.of(context).primaryColor,),
                            ),
                          ),
                        ),
                      ),
                    ),
                      ],
                    ),


                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
  }
}