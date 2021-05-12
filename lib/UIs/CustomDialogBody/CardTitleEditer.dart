import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:taskslide/state/state.dart';

class CardTitleEditer extends StatefulWidget {
  final String previousTitle;
  final String  previousColor;
  final String mainId;
  final String subId;

  const CardTitleEditer({Key key, this.previousTitle, this.previousColor ="#9E9F9F", this.mainId, this.subId,}) : super(key: key);

  @override
  _CardTitleEditerState createState() => _CardTitleEditerState();
}

class _CardTitleEditerState extends State<CardTitleEditer> {

  TextEditingController _controller = TextEditingController(text: "");

  final taskState = Get.put(TaskState());

List<String> colors = [
  // Color(0xFFE81E62),
  // Color(0xFFFEEA3B),
  // Color(0xFF9D26B0),
  // Color(0xFF3F51B5),
  // Color(0xFF0cec17),
  // Color(0xFFf77e12),  
  // Color(0xFF02A8F4),
  // Color(0xFFFF9800),
  // Color(0xFFFE5622),
  // Color(0xFF4DAE50),
  // Color(0xFFF44237),
  // Color(0xFF9E9F9F),
  // Colors.transparent,
  


  "#E81E62",
  "#0FEEA3B",
  "#09D26B0",
  "#03F51B5",
  "#00cec17",
  "#0f77e12",  
  "#002A8F4",
  "#0FF9800",
  "#0FE5622",
  "#04DAE50",
  "#0F44237",
  "#09E9F9F",
  "#0",
  ];

bool showColors = false;

int selectedColor = -1;

String chosenColor = "#9E9F9F";

bool confirmDelete = false;

  @override
  void initState() { 
    super.initState();
    chosenColor = widget.previousColor;
    _controller = TextEditingController(text:"${widget.previousTitle}");
  }

  @override
  Widget build(BuildContext context) {
    
    return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top:12.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          margin: EdgeInsets.all(0.0),
          child: Container(
            width: 280.0,
            child: Column(
              children: [
                SizedBox(height: 8.0,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 4.0,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                    confirmDelete != true? MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                  confirmDelete = true;                              
                              });
                            },
                            child: Icon(Icons.delete_outline,color: Colors.red,size: 20.0,)),
                        ),
                    ):
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("  Delete?",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),),
                          ),

                          SizedBox(width: 30,),

                           GestureDetector(
                            onTap: (){

                            // null if you're editing main list
                            if(widget.subId != null){
                              taskState.deleteChildCardClick(num.parse(widget.mainId),num.parse(widget.subId),);
                            }else{
                              taskState.deleteParentCardClick(num.parse(widget.mainId),);
                            }
                            
                            Navigator.pop(context);
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

                      Flexible(child: Text(confirmDelete != true? "Edit":"",
                      style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).disabledColor,
                      fontWeight: FontWeight.bold,),),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Icon(
                          Icons.close,
                          color: Theme.of(context).disabledColor,size: 20.0,),
                        ),
                      ),
                    ],
                  ),
                ),
                            
              // Textfield for name
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 35.0,
                  decoration: BoxDecoration(
                    color:Theme.of(context).disabledColor.withOpacity(.06),
                    borderRadius: BorderRadius.circular(8.0,),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:4.0,left: 4.0,right: 4.0),
                    // padding: const EdgeInsets.only(bottom:12.0,left: 4.0),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,   
                        hintText: "title",  
                        contentPadding: EdgeInsets.symmetric(horizontal: 4.0),                                
                      ),
                    ),
                  ),),
              ),


                            // Color Option
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: (){
                                setState(() {
                                  showColors = ! showColors;                                        
                                  });
                                },
                                child: Container(
                                  height: 35.0,
                                  width: 300.0,
                                  decoration: BoxDecoration(
                                    color:Theme.of(context).disabledColor.withOpacity(.06),
                                    borderRadius: BorderRadius.circular(8.0,),
                                  ),
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    alignment: WrapAlignment.spaceBetween,
                                    children: [
                                      Wrap(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              
                                              decoration: BoxDecoration(
                                                color: taskState.hexToColor(chosenColor),
                                                shape: BoxShape.circle ,
                                                border: Border.all(color: Theme.of(context).disabledColor,),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text("$chosenColor"),
                                      RotatedBox(
                                      quarterTurns: showColors == false? 3 : 1,
                                      child: Icon(Icons.chevron_left,color: Theme.of(context).disabledColor,)),
                                    ],
                                  ),
                                  ),
                              ),
                            ),

                          showColors ==true?Card(
                              elevation: 20.0,
                              //shadowColor: Colors.transparent,
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(8.0),
                             ),
                             child: Column(
                               children: [
                                 SizedBox(height: 12.0,),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal:4.0),
                                      child: Text("Choose Color"),
                                    ),),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        showColors = !showColors;                                                                                 
                                    });
                                  },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right:8.0),
                                      child: Icon(
                                      Icons.close,
                                      color: Theme.of(context).disabledColor,size: 20.0,),
                                    ),
                                  ),
                                  ],                                   
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                   child: Divider(),
                                 ),

                                 Wrap(
                                   crossAxisAlignment: WrapCrossAlignment.center,
                                   alignment: WrapAlignment.center,
                                   children: [

                                     for(int index = 0; index<=colors.length-1;index++)

                                     if (index == colors.length-1)

                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: GestureDetector(
                                           onTap: (){
                                             setState(() {
                                                selectedColor = index;  
                                                chosenColor = colors[index];                                               
                                                });
                                              },
                                            child: MouseRegion(
                                              cursor: SystemMouseCursors.click,
                                              child: Container(
                                                 height: 30.0,
                                                 width: 60.0,
                                                 decoration: BoxDecoration(
                                                   border: Border.all(width: 2,color: Theme.of(context).disabledColor,),
                                                   //color: taskState.hexToColor(colors[index]),
                                                   borderRadius: BorderRadius.circular(12),
                                                 ),
                                                 child: Center(
                                                   child:Container(child: Text("Reset",style: TextStyle(
                                                     fontWeight: FontWeight.bold,
                                                     color: Theme.of(context).disabledColor,
                                                   ),),),
                                                 ),
                                               ),
                                            ),
                                          ),
                                        )

                                    else
                                     Padding(
                                       padding: const EdgeInsets.all(4.0),
                                       child: GestureDetector(
                                         onTap: (){
                                           setState(() {
                                              selectedColor = index;  
                                              chosenColor = colors[index];                                               
                                        });
                                         },
                                         child: Container(
                                           height: 45.0,
                                           width: 45.0,
                                           decoration: BoxDecoration(
                                             shape: BoxShape.circle,
                                             color:taskState.hexToColor(colors[index]),
                                           ),
                                           child: Center(
                                             child:selectedColor == index? Icon(Icons.done) : Container(),
                                           ),
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),
                                SizedBox(height: 15,),
                               ],
                             ),
                            ):Container(),

                            // SAVE
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: (){
                                        setState(() {                                                                                                                                                                

                                        // null if you're editing main list   
                                        if(widget.subId != null){
                                          taskState.editChildCardDetailsClick(
                                            num.parse(widget.mainId),
                                            num.parse(widget.subId),
                                            name: _controller.text.toString(),
                                            color: chosenColor,
                                          );
                                        }else{
                                        taskState.editCardUpdateClick(
                                          num.parse(widget.mainId), 
                                          name: _controller.text.toString(),
                                          color: chosenColor,                                           
                                          );
                                        }
                                          });
                                          //print(taskState.taskList);
                                          Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 35.0,
                                        width: 300.0,
                                        decoration: BoxDecoration(
                                          color:Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.circular(8.0,),
                                        ),
                                        child: Center(
                                          child: Text("Update",style: TextStyle(
                                            color: Theme.of(context).cardColor,
                                          ),),
                                        ),
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
                  ),
                ],
              );
            }
          }