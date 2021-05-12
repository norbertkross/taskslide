import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskslide/state/state.dart';
import 'package:timeago/timeago.dart' as timeago;

class CalenderTaskItem extends StatefulWidget {

  final int index;

  const CalenderTaskItem({Key key, 
  this.index,
   }) : super(key: key);
  @override
  _CalenderTaskItemState createState() => _CalenderTaskItemState();
}

class _CalenderTaskItemState extends State<CalenderTaskItem> {

  final taskState = Get.put(TaskState());

  bool isOpened = false;

  String giveTime(String time){
    return timeago.format(DateTime.parse(time),
    );
  }

dateTimeRangePicker(int index) async {
  DateTimeRange picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime(DateTime.now().year - 2),
    lastDate: DateTime(DateTime.now().year + 10),
    initialDateRange: DateTimeRange(
      start: DateTime.now(),
      end:DateTime(
          DateTime.now().year, 
          DateTime.now().month, 
          DateTime.now().day+3),
      
    ),
  );

  if(picked != null){
  taskState.setDateRange(index,start: "${picked.start}",end: "${picked.end}");
  }
} 


  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    double totalItemWidth = mq.width >=500? 450.0:mq.width;

    return Container(
      padding: EdgeInsets.all(8),
      //color: Colors.amber,
      width: totalItemWidth,
      child: GetBuilder<TaskState>(builder: (builder)=>
         Column(
          children: [
            SizedBox(
              width: mq.width,
              child: Wrap(              
                direction: Axis.vertical,
                alignment: WrapAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0+2.0+2),
                    child: Text( taskState.allTasks[widget.index]["date-start"].length>0?taskState.allTasks[widget.index]["date-start"].substring(0,10): "Not Set",
                     style: TextStyle(
                      color: Theme.of(context).disabledColor,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),

                  Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: Center(
                          child: Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).canvasColor,
                          ),
                      ),
                        ),
                      ),
                      SizedBox(width: 2,),
                      Column(
                        children: [
                          
                          Container(
                            height: 4,
                            width: totalItemWidth - (12.0+2.0+/*Padding=>*/16.0+/*Random subtraction=>*/80.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 5,),

              // Card Body

              Padding(
                padding: const EdgeInsets.only(left:25.0,right:(/*Random subtraction=>*/80.0)),
                child: Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Container(
                    padding: EdgeInsets.only(left: 6,),
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: mq.width,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                      ),
                      width: mq.width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        SizedBox(height: 16,),
                        Text("Created: ${giveTime(taskState.allTasks[widget.index]["date-time"])}",style: TextStyle(
                          color: Theme.of(context).disabledColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),),
                        SizedBox(height: 12,),
                        Text(taskState.allTasks[widget.index]["project-name"] ?? "Project Name",
                         style: TextStyle(
                          color:Theme.of(context).primaryColor,
                           fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),),
                        SizedBox(height: 12,),
                        Text("Tasks: ${taskState.allTasks[widget.index]["project-body"].length.toString()} task(s)",style: TextStyle(
                          color: Theme.of(context).disabledColor,
                          //fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),),

                        SizedBox(height: 20,),

                        // people
                       SizedBox(
                          width: mq.width,
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                  isOpened = !isOpened;                                
                              });
                            },
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                              RotatedBox(quarterTurns:isOpened == true?1:3,
                              child: Icon(Icons.chevron_left,color: Theme.of(context).primaryColor,),),
                              SizedBox(width: 8,),
                              Text("Members",style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor,
                                  ),),
                            ],),
                          ),
                        ),

                       isOpened == true? Container(
                          //color: Colors.amber.withOpacity(.2),
                          height: taskState.allTasks[widget.index]["people"].length == 0?5 : 150.0,
                          child: ListView(
                            children: [
                             taskState.allTasks[widget.index]["people"].length == 0? Padding(
                                padding: const EdgeInsets.symmetric(vertical:6.0),
                                child: Text("No members added yet  ",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).disabledColor,
                                ),),
                              ):Container(),
                            
                            for (var i = 0; i <= taskState.allTasks[widget.index]["people"].length-1; i++)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical:6.0),
                                child: Text("${taskState.allTasks[widget.index]["people"][i]}  ",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).disabledColor,
                                ),),
                              ),
                            ],
                          ),
                        ):Container(),

                        SizedBox(
                          width: mq.width,
                          child: Wrap(
                            alignment: WrapAlignment.end,
                            children: [
                            IconButton(
                            hoverColor: Colors.transparent,
                            tooltip: "Set date",
                            icon: Icon(Icons.date_range_outlined,
                            size: 18.0,
                            color:Colors.green), 
                            onPressed: (){                            
                                dateTimeRangePicker(widget.index);
                                setState(() { });
                              }), 
                            ],
                          ),
                        ),                        
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            SizedBox(height: 10,),

            SizedBox(
              width: mq.width,
              child: Wrap(              
                direction: Axis.vertical,
                alignment: WrapAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0+2.0+2),
                    child: Text(taskState.allTasks[widget.index]["date-end"].length>0?taskState.allTasks[widget.index]["date-end"].substring(0,10): "Not Set",style: TextStyle(
                      color: Theme.of(context).disabledColor,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),

                  Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffffc100),
                        ),
                        child: Center(
                          child: Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).canvasColor,
                          ),
                      ),
                        ),
                      ),
                      SizedBox(width: 2,),
                      Column(
                        children: [
                          
                          Container(
                            height: 4,
                            width: totalItemWidth - (12.0+2.0+/*Padding=>*/16.0+/*Random subtraction=>*/80.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color(0xffffc100),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}